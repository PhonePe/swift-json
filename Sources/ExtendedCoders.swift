//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

/// A custom decoder.
public struct ExtendedDecoder: Decoder {
    private var base: Decoder
    public init(_ base: Decoder) {
        self.base = base
    }

    public var codingPath: [CodingKey] {
        return base.codingPath
    }
    
    public var userInfo: [CodingUserInfoKey: Any] {
        return base.userInfo
    }
    
    public func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        return .init(ExtendedKeyedDecodingContainer(try base.container(keyedBy: type), parent: self))
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return ExtendedUnkeyedDecodingContainer(try base.unkeyedContainer(), parent: self)
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return ExtendedSingleValueDecodingContainer(try base.singleValueContainer(), parent: self)
    }
}

/// A proxy for `Decodable` that forces our custom decoder to be used.
public struct ExtendedDecodable<T: Decodable>: Decodable {
    public var value: T
    
    public init(from decoder: Decoder) throws {
        let decoder = ExtendedDecoder(decoder)
        if let type = T.self as? opaque_DecodableSupertype.Type {
            self.value = try cast(try type.opaque_ProxyDecodableType().init(from: decoder).opaque_getValue()) as T
        } else {
            self.value = try T.init(from: decoder)
        }
    }
}

/// A custom encoder.
public struct ExtendedEncoder: Encoder {
    private var base: Encoder
    public init(_ base: Encoder) {
        self.base = base
    }
    
    public var codingPath: [CodingKey] {
        return base.codingPath
    }
    
    public var userInfo: [CodingUserInfoKey: Any] {
        return base.userInfo
    }
    
    public func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        return .init(ExtendedKeyedEncodingContainer(base.container(keyedBy: type), parent: self))
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        return ExtendedUnkeyedEncodingContainer(base.unkeyedContainer(), parent: self)
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        return ExtendedSingleValueEncodingContainer(base.singleValueContainer(), parent: self)
    }
}

/// A proxy for `Encodable` that forces our custom encoder to be used.
public struct ExtendedEncodable<T: Encodable>: Encodable {
    public var value: T
    public init(_ value: T) {
        self.value = value
    }
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: ExtendedEncoder(encoder))
    }
}
