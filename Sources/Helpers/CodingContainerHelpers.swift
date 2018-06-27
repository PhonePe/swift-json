//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

// MARK: - Shorthands -

extension KeyedDecodingContainerProtocol {
    public func decode<T: Decodable>(forKey key: Key) throws -> T {
        return try decode(T.self, forKey: key)
    }
}

// MARK: - Optional Decoding -

extension KeyedDecodingContainerProtocol {
    
    internal func _decode<T: Decodable>(optional type: T.Type, forKey key: Key) throws -> T? {
        do {
            return try decodeIfPresent(T.self, forKey: key)
        } catch {
            if case DecodingError.keyNotFound(_, _) = error {
                return nil
            } else if case DecodingError.valueNotFound(_, _) = error {
                return nil
            } else if case DecodingError.typeMismatch(_, _) = error {
                do {
                    return try decode(EmptyJSON<T>.self, forKey: key).value
                } catch {
                    throw error
                }
            } else {
                throw error
            }
        }
    }
    
    public func decode<T: Decodable & OptionalProtocol>(optional type: T.Wrapped.Type, forKey key: Key) throws -> T where T.Wrapped: Decodable {
        return .init(try _decode(optional: T.Wrapped.self, forKey: key))
    }
    
    public func decode<T: Decodable>(optional type: T.Type, forKey key: Key) throws -> T? {
        return .init(try _decode(optional: T.self, forKey: key))
    }

    public func decode<T: Decodable & OptionalProtocol>(forKey key: Key) throws -> T where T.Wrapped: Decodable {
        return try decode(optional: T.Wrapped.self, forKey: key)
    }
}

extension SingleValueDecodingContainer {
    
    internal func _decode<T: Decodable>(optional type: T.Type) throws -> T? {
        guard !decodeNil() else {
            return nil
        }
        do {
            return try decode(T.self)
        } catch {
            if case DecodingError.keyNotFound(_, _) = error {
                return nil
            } else if case DecodingError.valueNotFound(_, _) = error {
                return nil
            } else if case DecodingError.typeMismatch(_, _) = error {
                do {
                    return try decode(EmptyJSON<T>.self).value
                } catch {
                    throw error
                }
            } else {
                throw error
            }
        }
    }
    
    public func decode<T: Decodable & OptionalProtocol>(optional type: T.Wrapped.Type) throws -> T where T.Wrapped: Decodable {
        return .init(try _decode(optional: T.Wrapped.self))
    }
    
    public func decode<T: Decodable>(optional type: T) throws -> T? {
        return .init(try _decode(optional: T.self))
    }
    
    public func decode<T: Decodable & OptionalProtocol>() throws -> T where T.Wrapped: Decodable {
        return try decode(optional: T.Wrapped.self)
    }
}

extension UnkeyedDecodingContainer {
    
    internal mutating func _decode<T: Decodable>(optional type: T.Type) throws -> T? {
        guard !isAtEnd else {
            return nil
        }
        do {
            return try decodeIfPresent(T.self)
        } catch {
            if case DecodingError.keyNotFound(_, _) = error {
                return nil
            } else if case DecodingError.valueNotFound(_, _) = error {
                return nil
            } else if case DecodingError.typeMismatch(_, _) = error {
                do {
                    return try decode(EmptyJSON<T>.self).value
                } catch {
                    throw error
                }
            } else {
                throw error
            }
        }
    }
    
    public mutating func decode<T: Decodable & OptionalProtocol>(optional type: T.Wrapped.Type) throws -> T where T.Wrapped: Decodable {
        return .init(try _decode(optional: T.Wrapped.self))
    }
    
    public mutating func decode<T: Decodable>(optional type: T) throws -> T? {
        return .init(try _decode(optional: T.self))
    }
    
    public mutating func decode<T: Decodable & OptionalProtocol>() throws -> T where T.Wrapped: Decodable {
        return try decode(optional: T.Wrapped.self)
    }
}
