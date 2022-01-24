//
//  CatFactApi.swift
//  
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import Foundation

protocol CatFactApiProtocol {
    var networkClient: NetworkClientProtocol { get }
    func getCatFact(id: String) -> AnyPublisher<CatFactApi.CatFact, Error>
    func getCatFacts() -> AnyPublisher<[CatFactApi.CatFact], Error>
}

struct CatFactApi: CatFactApiProtocol {
    @Inject var networkClient: NetworkClientProtocol

    func getCatFacts() -> AnyPublisher<[CatFact], Error> {
        networkClient.get(type: [CatFact].self, url: Endpoint.facts.url)
    }

    func getCatFact(id: String) -> AnyPublisher<CatFact, Error> {
        networkClient.get(type: CatFact.self, url: Endpoint.fact(id: id).url)
    }
    
    struct Endpoint {
        var path: String
        var url: URL {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "cat-fact.herokuapp.com"
            components.path = path
            guard let url = components.url else {
                fatalError("URL inválida: \(components)")
            }
            return url
        }

        static var facts: Self {
            Endpoint(path: "/facts")
        }

        static func fact(id: String) -> Self {
            Endpoint(path: "/facts/\(id)")
        }
    }
}

extension CatFactApi {
    struct CatFact: Decodable {
        let id: String
        let text: String

        enum CodingKeys: String, CodingKey {
            case text
            case id = "_id"
        }
    }
}

extension CatFactApi.CatFact {
    func asDomainModel() -> CatFact {
        CatFact(id: id, text: text)
    }
}
