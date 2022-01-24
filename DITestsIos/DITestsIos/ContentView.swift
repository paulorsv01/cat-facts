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
                .navigationTitle("Fatos sobre gatinhos 🐈")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(.stack)
                .toolbar {
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

        init() {
            CatFactsDI.shared.registerUserToken(userTokenPublisher: lockStatus.publisher)
        }

        func toggleLock() {
            lockStatus.toggle()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
