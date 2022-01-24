//
//  NetworkClient.swift
//  
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import Foundation

protocol NetworkClientProtocol {
    func get<T>(type: T.Type, url: URL) -> AnyPublisher<T, Error> where T: Decodable
}

struct NetworkClient: NetworkClientProtocol {
    func get<T>(type: T.Type, url: URL) -> AnyPublisher<T, Error> where T : Decodable {
        let request = URLRequest(url: url)
        print(url)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
