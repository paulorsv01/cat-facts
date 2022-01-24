//
//  DITestsApp.swift
//  DITests
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import SwiftUI
import InternalApp

class ExternalAppSettings: AppSettingsProtocol {
    private var cancellables = Set<AnyCancellable>()
    
    // Listener para a propriedade lock
    
    private var lockSubject: CurrentValueSubject<Bool, Never> = .init(false)
    
    lazy var lockPublisher: AnyPublisher<Bool, Never> = {
        lockSubject.eraseToAnyPublisher()
    }()
    
    func updateLock(newValue: Bool) {
        lockSubject.send(newValue)
    }
    
    func addLockListener() {
        NotificationCenter.default.publisher(for: Notification.Name("updateLock"))
            .sink { [weak self] notification in
                self?.updateLock(newValue: notification.object as! Bool)
            }
            .store(in: &cancellables)
    }
    
    // Listener para a propriedade color
    
    var colors: [Color] = [.green, .blue, .cyan, .pink]
    
    // O publisher de fato, o que emite um valor quando a cor se altera
    private var colorSubject: CurrentValueSubject<Color, Never> = .init(.green)
    
    // Uma versão "publica" do publisher acima. Quem quer escutar a alteração dele, escuta esse aqui.
    lazy var colorPublisher: AnyPublisher<Color, Never> = {
        colorSubject.eraseToAnyPublisher()
    }()
    
    func updateColor() {
        colorSubject.send(colors.randomElement()!)
    }
    
    func addColorListener() {
        NotificationCenter.default.publisher(for: Notification.Name("updateColor"))
            .sink { [weak self] _ in
                self?.updateColor()
            }
            .store(in: &cancellables)
    }
    
    var text: String = ":("
    
    init() {
        addLockListener()
        addColorListener()
    }
}

@main
struct DITestsApp: App {
    init() {
        CatFactsDI.prepare(appSettings: ExternalAppSettings())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.hiddenTitleBar)
    }
}
