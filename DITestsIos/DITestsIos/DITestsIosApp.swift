//
//  DITestsIosApp.swift
//  DITestsIos
//
//  Created by Paulo Vieira on 21/01/22.
//

import SwiftUI
import InternalApp

@main
struct DITestsIosApp: App {

    init() {
        CatFactsDI.prepare()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
