//
//  LockStatus.swift
//  DITests
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import Foundation

struct LockStatus {
    private var lockSubject = CurrentValueSubject<Bool, Never>(false)
    lazy var publisher: AnyPublisher<Bool, Never> = {
        lockSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }()
    
    var lock: Bool {
        get {
            lockSubject.value
        }
        set {
            lockSubject.send(newValue)
        }
    }
    
    mutating func toggle() {
        lock.toggle()
    }
}
