//
//  CatFactRepository.swift
//  
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import Foundation

struct CatFactRepository: CatFactRepositoryProtocol {
    @Inject private var catApi: CatFactApiProtocol

    func getCatFacts() -> AnyPublisher<[CatFact], Never> {
        catApi.getCatFacts()
            .map { catFacts in
                catFacts.map { $0.asDomainModel() }
            }
            .replaceError(with: [CatFact(id: "1", text: "miau")])
            .eraseToAnyPublisher()
    }

    func getCatFact(id: String) -> AnyPublisher<CatFact, Never> {
        catApi.getCatFact(id: id)
            .map { $0.asDomainModel() }
            .replaceError(with: CatFact(id: "1", text: "miau"))
            .eraseToAnyPublisher()
    }
}
