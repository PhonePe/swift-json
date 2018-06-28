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
    
    public mutating func add(_ error: Error) {
        value.append(error)
    }
    
    public mutating func silence<T>(_ expr: (@autoclosure () throws -> T)) -> T? {
        do {
            return try expr()
        } catch {
            add(error)
            return nil
        }
    }
    
    public func accumulated(file: StaticString = #file, function: StaticString = #function, line: Int = #line) -> AccumulatedErrors {
        return .init(errors: value, file: file, function: function, line: line)
    }
}

public struct AccumulatedErrors: CustomStringConvertible, Error {
    public let errors: [Error]
    public let file: StaticString
    public let function: StaticString
    public let line: Int
    
    public init(errors: [Error], file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        self.errors = errors
        self.file = file
        self.function = function
        self.line = line
    }
    public var description: String {
        return "Error in file: \(file), line: \(line), function: \(function): \(errors.description)"
    }
    
    public var name: String {
        if let first = errors.first {
            return String(describing: first)
        } else {
            return "Empty error in file: \(file), line: \(line), function: \(function)"
        }
    }
}

public enum JSONRuntimeError: Error {
    case irrepresentableNumber(NSNumber)
    case invalidTypeCast(from: Any.Type, to: Any.Type)
    case noFallbackCovariantForSupertype(Any.Type)
    case stringEncodingError
    case unexpectedlyFoundNil(file: StaticString, function: StaticString, line: UInt)
}

extension Optional {
    public func unwrapOrThrowJSONRuntimeError(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) throws -> Wrapped {
        return try unwrapOrThrow(JSONRuntimeError.unexpectedlyFoundNil(file: file, function: function, line: line))
    }
}
