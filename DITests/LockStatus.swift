//
//  LockStatus.swift
//  DITests
//
//  Created by Paulo Vieira on 21/01/22.
//

import Combine
import Foundation
import SwiftUI
import InternalApp

struct LockStatus {
    var lock: Bool = false
    mutating func toggle() {
        lock.toggle()
    }
}
