//
//  Inject.swift
//  
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import Foundation
import SwiftUI

@propertyWrapper struct Inject<Component> {
    private var component: Component

    init() {
        self.component = CatFactsDI.shared.resolve(Component.self)
    }
    
    var wrappedValue: Component {
        get { return component }
    }
}

@propertyWrapper struct AppSettings<T> {
    @Inject private var settings: AppSettingsProtocol
    private let keyPath: KeyPath<AppSettingsProtocol, T>
    
    init(_ keyPath: KeyPath<AppSettingsProtocol, T>) {
        self.keyPath = keyPath
    }
    
    var wrappedValue: T {
        get { return settings[keyPath: keyPath] }
    }
}
