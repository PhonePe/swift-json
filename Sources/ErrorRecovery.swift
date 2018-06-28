//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Swift

internal func attemptContainerAgnosticRecovery<T: Decodable>(for type: T.Type, error: Error) -> T? {
    
    if case DecodingError.keyNotFound(let key, _) = error {
        if let type = T.self as? opaque_OptionalProtocol.Type, let wrapped = type.opaque_Wrapped as? KeyConditionalNilDecodable.Type {
            if wrapped.mandatoryCodingKeys.contains(where: { $0.stringValue == key.stringValue }) {
                return try? cast(type.init(none: ()))
            }
        }
    }
    
    return nil
}

extension SingleValueDecodingContainer {
    internal func decodeIfPresentWithRecovery<T: Decodable>(_ type: T.Type) throws -> T? {
        guard !decodeNil() else {
            return nil
        }
        do {
            return try decode(T.self)
        } catch {
            do {
                return try decode(EmptyJSON<T>.self).value
            } catch(_) {
                throw error
            }
        }
    }
}

extension UnkeyedDecodingContainer {
    internal mutating func decodeIfPresentWithRecovery<T: Decodable>(_ type: T.Type) throws -> T? {
        guard !isAtEnd else {
            return nil
        }
        do {
            let decoded = try decodeIfPresent(JSON.self)
            
            if let decoded = decoded {
                if decoded.isEmpty {
                    return nil
                } else {
                    return try decoded.decode(as: T.self)
                }
            } else {
                return nil
            }
        } catch {
            return try attemptContainerAgnosticRecovery(for: T.self, error: error)
                .unwrapOrThrow(error)
        }
    }
}

extension KeyedDecodingContainerProtocol {
    
    internal func decodeIfPresentWithRecovery<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T? {
        do {
            return try decodeIfPresent(T.self, forKey: key)
        } catch {
            do {
                return try decode(EmptyJSON<T>.self, forKey: key).value
            } catch(_) {
                return try attemptContainerAgnosticRecovery(for: T.self, error: error).unwrapOrThrow(error)
            }
        }
    }
}

