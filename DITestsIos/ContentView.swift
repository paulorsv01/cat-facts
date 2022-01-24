//
//  ContentView.swift
//  DITestsIOS
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import SwiftUI
import InternalApp

struct ContentView: View {
    @StateObject var viewModel: ContentViewViewModel = ContentViewViewModel()
    var body: some View {
        NavigationView {
            CatFactsView()
                .navigationBarTitle("Testes de DI")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.updateColor()
                        } label: {
                            Image(systemName: "paintpalette.fill")
                        }
                        Button {
                            viewModel.toggleLock()
                        } label: {
                            Image(systemName: viewModel.lockStatus.lock ? "lock.fill" : "lock.open.fill")
                        }
                    }
                }
        }
    }
}

extension ContentView {
    class ContentViewViewModel: ObservableObject {
        @Published var lockStatus: LockStatus = LockStatus()
        
        deinit {
            print(String(describing: self), "deinit")
        }
        
        func updateColor() {
            NotificationCenter.default.post(name: Notification.Name("updateColor"), object: nil)
        }
        
        func toggleLock() {
            lockStatus.toggle()
            NotificationCenter.default.post(name: Notification.Name("updateLock"), object: lockStatus.lock)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
