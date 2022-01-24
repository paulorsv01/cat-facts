//
//  GetCatFactUseCase.swift
//  
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import Foundation

struct GetCatFactUseCase {
    private var repository: CatFactRepositoryProtocol

    init(repository: CatFactRepositoryProtocol) {
        self.repository = repository
    }

    func invoke(id: String) -> AnyPublisher<CatFact, Never> {
        repository.getCatFact(id: id)
    }
}
