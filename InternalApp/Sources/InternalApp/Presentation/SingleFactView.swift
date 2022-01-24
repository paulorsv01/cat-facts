//
//  SingleFactView.swift
//  
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import SwiftUI

struct SingleFactView: View {
    @StateObject var viewModel: SingleFactViewModel = SingleFactViewModel()
    @State var id: String
    @State var color: Color = .red
    @AppSettings(\.colorPublisher) var colorPublisher
    @AppSettings(\.text) var text
    
    var body: some View {
        if !viewModel.lockStatus.lock {
            content
                .onAppear {
                    viewModel.load(id: id)
                }
        } else {
            VStack {
                Image(systemName: "lock.fill")
                Text(text)
            }
            .foregroundColor(color)
            .onReceive(colorPublisher) { color in
                self.color = color
            }
                
        }
    }
    
    @ViewBuilder private var content: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
            
        case .loading:
            ProgressView()
            
        case .error:
            Text("Deu ruim...")
            
        case .loaded(let fact):
            Text(fact.id)
        }
    }
}

extension SingleFactView {
    class SingleFactViewModel: ObservableObject {
        enum State {
            case idle
            case loading
            case error
            case loaded(CatFact)
        }
        
        @Published private(set) var state: State = State.idle
        @Inject private var repository: CatFactRepositoryProtocol
        @Inject var lockStatus: LockStatus
        
        private var cancellables = Set<AnyCancellable>()
        
        init() {
            lockStatus.objectWillChange
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        }
        
        deinit {
            print(String(describing: self), "deinit")
        }
                
        func load(id: String) {
            state = .loading
            GetCatFactUseCase(repository: repository).invoke(id: id)
                .sink { completion in
                    switch completion {
                    case .failure(_):
                        self.state = .error
                        
                    case .finished:
                        break
                    }
                } receiveValue: { catFacts in
                    DispatchQueue.main.async {
                        self.state = .loaded(catFacts)
                    }
                }
                .store(in: &cancellables)
        }
    }
}

struct SingleFactView_Previews: PreviewProvider {
    static var previews: some View {
        SingleFactView(id: "")
    }
}
