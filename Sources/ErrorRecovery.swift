//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Swift

internal func attemptContainerAgnosticDecodeRecovery<T: Decodable>(type: T.Type, error: Error) -> T? {
    
    if case DecodingError.keyNotFound(let key, _) = error {
        if let type = T.self as? opaque_OptionalProtocol.Type, let wrapped = type.opaque_Wrapped as? KeyConditionalNilDecodable.Type {
            if wrapped.mandatoryCodingKeys.contains(where: { $0.stringValue == key.stringValue }) {
                return try? cast(type.init(none: ()))
            }
        }
    }
    
    return nil
}

internal func attemptDecodeRecovery<Container: KeyedDecodingContainerProtocol, T: Decodable>(container: Container, type: T.Type, key: Container.Key, error: Error) -> T? {
    return nil
}

internal func attemptDecodeIfPresentRecovery<Container: KeyedDecodingContainerProtocol, T: Decodable>(container: Container, type: T.Type, key: Container.Key, error: Error) -> T?? {
    
    do {
        return try container.decode(EmptyJSON.self, forKey: key).value
    } catch {
        
    }
    
    return nil
}

internal func attemptDecodeIfPresentRecovery<Container: SingleValueDecodingContainer, T: Decodable>(container: Container, type: T.Type, error: Error) -> T?? {
    
    do {
        return try container.decode(EmptyJSON.self).value
    } catch {
        
    }
    
    return nil
}

internal func attemptDecodeIfPresentRecovery<Container: UnkeyedDecodingContainer, T: Decodable>(container: Container, type: T.Type, error: Error) -> T?? {
    
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
                return try attemptContainerAgnosticDecodeRecovery(type: T.self, error: error).unwrapOrThrow(error)
            }
        }
    }
}

extension KeyedDecodingContainerProtocol {
    internal func decodeIfPresentWithRecovery<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T? {
        do {
            return try decodeIfPresent(T.self, forKey: key)
        } catch {
            if let value = attemptDecodeIfPresentRecovery(container: self, type: T.self, key: key, error: error) {
                return value
            } else if let value = attemptContainerAgnosticDecodeRecovery(type: T.self, error: error) {
                return value
            } else {
                logDecodeError(container: self, type: T.self, key: key, error: error)
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
            if let decoded = try decodeIfPresent(JSON.self) {
                if decoded.isEmpty {
                    return nil
                } else {
                    return try decoded.decode(as: T.self)
                }
            } else {
                return nil
            }
        } catch {
            if let value = attemptDecodeIfPresentRecovery(container: self, type: T.self, error: error) {
                return value
            } else if let value = attemptContainerAgnosticDecodeRecovery(type: T.self, error: error) {
                return value
            } else {
                logDecodeError(container: self, type: T.self, error: error)
                throw error
            }
        }
    }
}
