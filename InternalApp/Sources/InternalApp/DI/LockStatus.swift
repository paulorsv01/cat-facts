//
//  LockStatus.swift
//  
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import Foundation

class LockStatus: ObservableObject {
    @Published var lock: Bool = false
    
    init(lockPublisher: AnyPublisher<Bool, Never>) {
        self.lock = .init()
        lockPublisher.assign(to: &$lock)
    }
}
