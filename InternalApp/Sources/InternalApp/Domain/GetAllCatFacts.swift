//
//  GetAllCatFacts.swift
//  
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import Foundation

struct GetAllCatFactsUseCase {
    private var repository: CatFactRepositoryProtocol

    init(repository: CatFactRepositoryProtocol) {
        self.repository = repository
    }

    func invoke() -> AnyPublisher<[CatFact], Never> {
        repository.getCatFacts()
    }
}
