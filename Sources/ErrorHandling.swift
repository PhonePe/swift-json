//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

public struct ErrorLocation {
    public let file: StaticString
    public let function: StaticString
    public let line: Int
    
    public init(file: StaticString, function: StaticString, line: Int) {
        self.file = file
        self.function = function
        self.line = line
    }
    
    public var description: String {
        return "file: \(file), function: \(function), line: \(line)"
    }
}

public struct ErrorAccumulator {
    private var locations: [ErrorLocation]
    private var errors: [Error]
    
    public init() {
        self.locations = []
        self.errors = []
    }
    
    public mutating func add(_ error: Error, file: StaticString = #function, function: StaticString = #function, line: Int = #line) {
        if let error = error as? AccumulatedErrors {
            locations += error.locations
            errors += error.errors
        } else {
            errors.append(error)
        }
    }
    
    public mutating func silence<T>(_ expr: (@autoclosure () throws -> T), file: StaticString = #function, function: StaticString = #function, line: Int = #line) -> T? {
        do {
            return try expr()
        } catch {
            add(error, file: file, function: function, line: line)
            return nil
        }
    }
    
    public func accumulated(file: StaticString = #file, function: StaticString = #function, line: Int = #line) -> AccumulatedErrors {
        return .init(locations: locations, errors: errors, file: file, function: function, line: line)
    }
}

public struct AccumulatedErrors: CustomStringConvertible, Error {
    fileprivate let locations: [ErrorLocation]
    fileprivate let errors: [Error]
    fileprivate let file: StaticString
    fileprivate let function: StaticString
    fileprivate let line: Int
    
    public init(locations: [ErrorLocation], errors: [Error], file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        self.locations = locations
        self.errors = errors
        self.file = file
        self.function = function
        self.line = line
    }

    public init(errors: [Error], file: StaticString = #file, function: StaticString = #function, line: Int = #line) {
        self.locations = errors.map({ _ in ErrorLocation(file: file, function: function, line: line) })
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
    
    public var traceDescription: String  {
        var description: String = ""
        var indent: String = ""

        for (location, error) in zip(locations.reversed(), errors.reversed())  {
            description += indent + "From \(location.description):\n"
            description += indent + error.localizedDescription
            indent += "\t"
        }
        
        return description
    }
}

public enum JSONRuntimeError: Error {
    case noContainer
    case irrepresentableNumber(NSNumber)
    case invalidTypeCast(from: Any.Type, to: Any.Type)
    case noFallbackCovariantForSupertype(Any.Type)
    case stringEncodingError
    case unexpectedlyFoundNil(file: StaticString, function: StaticString, line: UInt)
    case isNotEmpty
}

extension Optional {
    public func unwrapOrThrowJSONRuntimeError(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) throws -> Wrapped {
        return try unwrapOrThrow(JSONRuntimeError.unexpectedlyFoundNil(file: file, function: function, line: line))
    }
}
