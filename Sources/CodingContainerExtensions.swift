//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

// MARK: - Shorthands -

extension KeyedDecodingContainerProtocol {
    public func decode<T: Decodable>(forKey key: Key) throws -> T {
        do {
            return try decode(T.self, forKey: key)
        } catch {
            logDecodeError(error: error, container: self, type: T.self, key: key)
            throw error
        }
    }
}

// MARK: - Optional Decoding -

extension KeyedDecodingContainerProtocol {
    public func decode<T: Decodable & OptionalProtocol>(optional type: T.Wrapped.Type, forKey key: Key) throws -> T where T.Wrapped: Decodable {
        return .init(try decodeIfPresentWithRecovery(T.Wrapped.self, forKey: key))
    }
    
    public func decode<T: Decodable>(optional type: T.Type, forKey key: Key) throws -> T? {
        return .init(try decodeIfPresentWithRecovery(T.self, forKey: key))
    }

    public func decode<T: Decodable & OptionalProtocol>(forKey key: Key) throws -> T where T.Wrapped: Decodable {
        return try decode(optional: T.Wrapped.self, forKey: key)
    }
}

extension SingleValueDecodingContainer {
    
    public func decode<T: Decodable & OptionalProtocol>(optional type: T.Wrapped.Type) throws -> T where T.Wrapped: Decodable {
        return .init(try decodeIfPresentWithRecovery(T.Wrapped.self))
    }
    
    public func decode<T: Decodable>(optional type: T.Type) throws -> T? {
        return .init(try decodeIfPresentWithRecovery(T.self))
    }
    
    public func decode<T: Decodable & OptionalProtocol>() throws -> T where T.Wrapped: Decodable {
        return try decode(optional: T.Wrapped.self)
    }
}

extension UnkeyedDecodingContainer {
    
    public mutating func decode<T: Decodable & OptionalProtocol>(optional type: T.Wrapped.Type) throws -> T where T.Wrapped: Decodable {
        return .init(try decodeIfPresentWithRecovery(T.Wrapped.self))
    }
    
    public mutating func decode<T: Decodable>(optional type: T.Type) throws -> T? {
        return .init(try decodeIfPresentWithRecovery(T.self))
    }
    
    public mutating func decode<T: Decodable & OptionalProtocol>() throws -> T where T.Wrapped: Decodable {
        return try decode(optional: T.Wrapped.self)
    }
}
