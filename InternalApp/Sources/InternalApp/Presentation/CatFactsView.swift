//
//  CatFactsView.swift
//  
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import SwiftUI

public struct CatFactsView: View {
    @StateObject var viewModel: AllFactsViewModel = AllFactsViewModel()

    public init() {}
    
    public var body: some View {
        content
    }

    @ViewBuilder private var content: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
                .onAppear {
                    viewModel.load()
                }

        case .loading:
            ProgressView()

        case .error:
            Text("Deu ruim...")

        case .loaded(let facts):
            List {
                ForEach(facts) { fact in
                    
                    NavigationLink(
                        tag: fact.id,
                        selection: $viewModel.currentSelectedCatFact) {
                            SingleFactView(id: fact.id)
                            
                        } label: {
                            Text(fact.text)
                        }

                    
                }
            }
            .refreshable {
                viewModel.load()
            }
            .listStyle(.plain)
        }
    }
}

extension CatFactsView {
    class AllFactsViewModel: ObservableObject {
        enum State {
            case idle
            case loading
            case error
            case loaded([CatFact])
        }
        
        deinit {
            print(String(describing: self), "deinit")
        }
        
        
        @Published private(set) var state: State = State.idle
        @Published var currentSelectedCatFact: String?
        @Inject private var repository: CatFactRepositoryProtocol
        
        private var cancellables = Set<AnyCancellable>()

        func load() {
            state = .loading
            GetAllCatFactsUseCase(repository: repository).invoke()
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

struct CatFactView_Previews: PreviewProvider {
    static var previews: some View {
        CatFactsView()
    }
}
