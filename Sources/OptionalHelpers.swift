//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

public protocol OptionalProtocol {
    associatedtype Wrapped
    var wrapped: Wrapped? { get }
    init(_ wrapped: Wrapped?)
}

extension Optional: OptionalProtocol {
    public var wrapped: Wrapped? {
        return self
    }
    
    public init(_ wrapped: Wrapped?) {
        self = wrapped
    }
}

extension Optional {
    internal enum UnwrappingError: Error {
        case foundNil(file: StaticString, function: StaticString, line: UInt)
    }
    
    internal func unwrapOrThrow(_ error: Error) throws -> Wrapped {
        if let result = self {
            return result
        } else {
            throw error
        }
    }
    
    internal func unwrap(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) throws -> Wrapped {
        return try unwrapOrThrow(UnwrappingError.foundNil(file: file, function: function, line: line))
    }
}
