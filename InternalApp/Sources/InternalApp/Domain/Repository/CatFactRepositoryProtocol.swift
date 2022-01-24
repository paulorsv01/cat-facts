//
//  CatFactRepositoryProtocol.swift
//  
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import Foundation

protocol CatFactRepositoryProtocol {
    func getCatFacts() -> AnyPublisher<[CatFact], Never>
    func getCatFact(id: String) -> AnyPublisher<CatFact, Never>
}
