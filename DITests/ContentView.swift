//
//  ContentView.swift
//  DITests
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import SwiftUI
import InternalApp

struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    var body: some View {
        NavigationView {
            CatFactsView()
                .toolbar {
                    Spacer()
                    Button {
                        viewModel.toggleLock()
                    } label: {
                        Image(systemName: viewModel.lockStatus.lock ? "lock.fill" : "lock.open.fill")
                    }
                }
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var lockStatus: LockStatus = LockStatus()
        
        deinit {
            print(String(describing: self), "deinit")
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
