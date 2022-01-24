//
//  CatFactsDI.swift
//  
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import Foundation
import SwiftUI
import Swinject

public protocol AppSettingsProtocol {
    // Propriedades reativas
    var colorPublisher: AnyPublisher<Color, Never> { get }
    var lockPublisher: AnyPublisher<Bool, Never> { get }
    
    // Propriedades não reativas, acesso sempre no mesmo dado (ou o dado é alterado pelo app pai por um set)
    var text: String { get }
}

public struct CatFactsDI {
    public static func prepare(appSettings: AppSettingsProtocol) {
        _ = shared
        let container = Container()
        container.register(NetworkClientProtocol.self) { _ in NetworkClient() }
            .inObjectScope(.container)
        container.register(CatFactApiProtocol.self) { _ in CatFactApi() }
            .inObjectScope(.container)
        container.register(CatFactRepositoryProtocol.self) { _ in return CatFactRepository() }
            .inObjectScope(.container)
        
        container.register(AppSettingsProtocol.self) { _ in appSettings }
        container.register(LockStatus.self) { _ in return LockStatus(lockPublisher: appSettings.lockPublisher)
        }
        
        shared.appSettings = appSettings
        shared.container = container
    }

    public static var shared: CatFactsDI = CatFactsDI()
    var appSettings: AppSettingsProtocol!

    private var container: Container!
    
    func register<T>(_ type: T.Type, factory: @escaping (Resolver) -> T) {
        container.register(type, factory: factory)
    }

    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }
}
