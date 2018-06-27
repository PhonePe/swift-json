//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

public struct ErrorAccumulator {
    private var value: [Error]
    
    public init() {
        self.value = []
    }
    
    mutating func add(_ error: Error) {
        value.append(error)
    }
    
    mutating func silence<T>(_ expr: (@autoclosure () throws -> T)) -> T? {
        do {
            return try expr()
        } catch {
            add(error)
            return nil
        }
    }
    
    public func accumulated() -> AccumulatedErrors {
        return .init(errors: value)
    }
}

public struct AccumulatedErrors: CustomStringConvertible, Error {
    public let errors: [Error]
    public var description: String {
        return errors.description
    }
}

public enum JSONRuntimeError: Error {
    case irrepresentableNumber(NSNumber)
    case invalidTypeCast(from: Any.Type, to: Any.Type)
    case noFallbackCovariantForSupertype(Any.Type)
}
