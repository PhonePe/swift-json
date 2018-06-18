//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

extension JSON {
    public init(jsonObject: Any?) throws {
        // TODO: Optimize by removing JSONSerialization dependency.
        if let jsonObject = jsonObject {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            self = try JSONDecoder().decode(JSON.self, from: data)
        } else {
            self = .null
        }
    }
    
    public func toData() throws -> Data? {
        guard self != .null else {
            return nil
        }
        return try JSONEncoder().encode(self)
    }

    public func toJSONObject() throws -> Any? {
        guard let data = try toData() else {
            return nil
        }
        // TODO: Optimize by removing JSONSerialization dependency.
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    public func toUnwrappedJSONObject() throws -> Any {
        return try toJSONObject().unwrap()
    }
}

extension KeyedEncodingContainerProtocol {
    public mutating func encodeJSONObject(_ value: Any?, forKey key: Key) throws {
        try encode(try JSON(jsonObject: value), forKey: key)
    }
}

extension KeyedDecodingContainerProtocol {
    public func decodeJSONObject(forKey key: Key) throws -> Any {
        return try decode(JSON.self, forKey: key).toUnwrappedJSONObject()
    }
    
    public func decodeJSONObject(forKey key: Key) throws -> Any? {
        return try _safeDecodeIfPresent(JSON.self, forKey: key)?.toUnwrappedJSONObject()
    }
    
    public func decodeJSONObject(forKey key: Key) throws -> [String: Any] {
        return try cast(decode(JSON.self, forKey: key).toUnwrappedJSONObject())
    }
    
    public func decodeJSONObject(forKey key: Key) throws -> [String: Any]? {
        return try castIfNotNil(_safeDecodeIfPresent(JSON.self, forKey: key)?.toUnwrappedJSONObject())
    }
    
    public func decodeJSONObject(forKey key: Key) throws -> [Any] {
        return try cast(decode(JSON.self, forKey: key).toUnwrappedJSONObject())
    }
    
    public func decodeJSONObject(forKey key: Key) throws -> [Any]? {
        return try castIfNotNil(_safeDecodeIfPresent(JSON.self, forKey: key)?.toUnwrappedJSONObject())
    }
}
