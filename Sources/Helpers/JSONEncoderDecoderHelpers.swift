//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

extension JSONEncoder {
    /// Use this instead of `JSONEncoder.encode(_:)`.
    public func extendedEncode<T: Encodable>(_ value: T) throws -> Data {
        return try encode(ExtendedEncodable(value))
    }
    
    /// Use this instead of `JSONEncoder.encode(_:)`.
    public func extendedEncodeToString<T: Encodable>(_ value: T) throws -> String {
        return try String(data: try encode(ExtendedEncodable(value)), encoding: .utf8).unwrap()
    }
}

extension JSONDecoder {
    /// Use this instead of `JSONDecoder.decode(_:)`.
    public func extendedDecode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try decode(ExtendedDecodable<T>.self, from: data).value
    }
    
    /// Use this instead of `JSONDecoder.decode(_:)`.
    public func extendedDecode<T: Decodable>(_ type: T.Type, from string: String) throws -> T {
        return try decode(ExtendedDecodable<T>.self, from: string.data(using: .utf8).unwrap()).value
    }
}

extension Encodable {
    public func toJSONString(prettyPrint: Bool = false) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting.formUnion(prettyPrint ? [.prettyPrinted] : [])
        return try encoder.extendedEncodeToString(self)
    }
}

extension Decodable {
    public init(jsonString string: String) throws {
        self = try JSONDecoder().extendedDecode(Self.self, from: string.data(using: .utf8).unwrap())
    }
}
