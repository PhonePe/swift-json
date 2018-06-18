//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

extension KeyedDecodingContainerProtocol {
    
    // `decodeIfPresent(_:forKey:)` seems to be bugged.
    public func _safeDecodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T? {
        do {
            return try decodeIfPresent(T.self, forKey: key)
        } catch {
            if case DecodingError.keyNotFound(_, _) = error {
                return nil
            } else if case DecodingError.valueNotFound(_, _) = error {
                return nil
            } else {
                throw error
            }
        }
    }

    public func decode<T: Decodable>(forKey key: Key) throws -> T {
        return try decode(T.self, forKey: key)
    }
    
    public func decode<T: Decodable & OptionalProtocol>(forKey key: Key) throws -> T where T.Wrapped: Decodable {
        return .init(try _safeDecodeIfPresent(T.Wrapped.self, forKey: key))
    }
}

extension UnkeyedDecodingContainer {
    public mutating func decode<T: Decodable>() throws -> T {
        return try decode(T.self)
    }
    
    public mutating func decode<T: Decodable & OptionalProtocol>() throws -> T where T.Wrapped: Decodable {
        return .init(try decodeIfPresent(T.Wrapped.self))
    }
}
