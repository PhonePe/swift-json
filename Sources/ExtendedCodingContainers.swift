//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

// MARK: - Decoding Containers -

public struct ExtendedSingleValueDecodingContainer: SingleValueDecodingContainer {
    private var parent: Decoder
    private var base: SingleValueDecodingContainer
    
    public init(_ base: SingleValueDecodingContainer, parent: Decoder) {
        self.parent = parent
        self.base = base
    }
    
    public var codingPath: [CodingKey] {
        return base.codingPath
    }
    
    public func decodeNil() -> Bool {
        return base.decodeNil()
    }
    
    public func decode(_ type: Bool.Type) throws -> Bool {
        return try base.decode(type)
    }
    
    public func decode(_ type: Int.Type) throws -> Int {
        return try base.decode(type)
    }
    
    public func decode(_ type: Int8.Type) throws -> Int8 {
        return try base.decode(type)
    }
    
    public func decode(_ type: Int16.Type) throws -> Int16 {
        return try base.decode(type)
    }
    
    public func decode(_ type: Int32.Type) throws -> Int32 {
        return try base.decode(type)
    }
    
    public func decode(_ type: Int64.Type) throws -> Int64 {
        return try base.decode(type)
    }
    
    public func decode(_ type: UInt.Type) throws -> UInt {
        return try base.decode(type)
    }
    
    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try base.decode(type)
    }
    
    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try base.decode(type)
    }
    
    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try base.decode(type)
    }
    
    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try base.decode(type)
    }
    
    public func decode(_ type: Float.Type) throws -> Float {
        return try base.decode(type)
    }
    
    public func decode(_ type: Double.Type) throws -> Double {
        return try base.decode(type)
    }
    
    public func decode(_ type: String.Type) throws -> String {
        return try base.decode(type)
    }
    
    // This is where the magic happens.
    
    public func decode<T: Decodable>(_ type: T.Type) throws -> T {
        return try base.decode(ExtendedDecodable<T>.self).value
    }
}

public struct ExtendedUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    private var parent: Decoder
    private var base: UnkeyedDecodingContainer
    
    public init(_ base: UnkeyedDecodingContainer, parent: Decoder) {
        self.parent = parent
        self.base = base
    }
    
    public var codingPath: [CodingKey] {
        return base.codingPath
    }
    
    public var count: Int? {
        return base.count
    }
    
    public var isAtEnd: Bool {
        return base.isAtEnd
    }
    
    public var currentIndex: Int {
        return base.currentIndex
    }
    
    public mutating func decodeNil() throws -> Bool {
        return try base.decodeNil()
    }
    
    public mutating func decode(_ type: Bool.Type) throws -> Bool {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: Int.Type) throws -> Int {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: Int8.Type) throws -> Int8 {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: Int16.Type) throws -> Int16 {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: Int32.Type) throws -> Int32 {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: Int64.Type) throws -> Int64 {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: UInt.Type) throws -> UInt {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: Float.Type) throws -> Float {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: Double.Type) throws -> Double {
        return try base.decode(type)
    }
    
    public mutating func decode(_ type: String.Type) throws -> String {
        return try base.decode(type)
    }
    
    // This is where the magic happens.
    
    public mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
        return try base.decode(ExtendedDecodable<T>.self).value
    }
    
    public mutating func decodeIfPresent<T: Decodable>(_ type: T.Type) throws -> T? {
        return try base.decodeIfPresent(ExtendedDecodable<T>.self)?.value
    }
    
    public mutating func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        return .init(ExtendedKeyedDecodingContainer(try base.nestedContainer(keyedBy: type), parent: parent))
    }
    
    public mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return ExtendedUnkeyedDecodingContainer(try base.nestedUnkeyedContainer(), parent: parent)
    }
    
    public mutating func superDecoder() throws -> Decoder {
        return ExtendedDecoder(try base.superDecoder())
    }
}

public struct ExtendedKeyedDecodingContainer<T: CodingKey>: KeyedDecodingContainerProtocol {
    public typealias Key = T
    
    private var base: KeyedDecodingContainer<Key>
    private var parent: Decoder
    
    public init(_ base: KeyedDecodingContainer<Key>, parent: Decoder) {
        self.parent = parent
        self.base = base
    }
    
    public var codingPath: [CodingKey] {
        return base.codingPath
    }
    
    public var allKeys: [Key] {
        return base.allKeys
    }
    
    public func contains(_ key: Key) -> Bool {
        return base.contains(key)
    }
    
    public func decodeNil(forKey key: Key) throws -> Bool {
        return try base.decodeNil(forKey: key)
    }
    
    public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        return try base.decode(type, forKey: key)
    }
    
    public func decode(_ type: String.Type, forKey key: Key) throws -> String {
        return try base.decode(type, forKey: key)
    }
    
    // This is where the magic happens.
    
    public func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        return try base.decode(ExtendedDecodable<T>.self, forKey: key).value
    }
    
    public func decodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T?  {
        return try base.decodeIfPresent(ExtendedDecodable<T>.self, forKey: key)?.value
    }
    
    public func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey>  {
        return .init(ExtendedKeyedDecodingContainer<NestedKey>(try base.nestedContainer(keyedBy: type, forKey: key), parent: parent))
    }
    
    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        return ExtendedUnkeyedDecodingContainer(try base.nestedUnkeyedContainer(forKey: key), parent: parent)
    }
    
    public func superDecoder() throws -> Decoder {
        return ExtendedDecoder(try base.superDecoder())
    }
    
    public func superDecoder(forKey key: Key) throws -> Decoder {
        return ExtendedDecoder(try base.superDecoder(forKey: key))
    }
}

// MARK: - Encoding Containers -

public struct ExtendedSingleValueEncodingContainer: SingleValueEncodingContainer {
    private var parent: Encoder
    private var base: SingleValueEncodingContainer
    
    public init(_ base: SingleValueEncodingContainer, parent: Encoder) {
        self.parent = parent
        self.base = base
    }
    
    public var codingPath: [CodingKey] {
        return base.codingPath
    }
    
    public mutating func encodeNil() throws {
        return try base.encodeNil()
    }
    
    public mutating func encode(_ value: Bool) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Int) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Int8) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Int16) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Int32) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Int64) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: UInt) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: UInt8) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: UInt16) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: UInt32) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: UInt64) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Float) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Double) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: String) throws {
        return try base.encode(value)
    }
    
    public mutating func encode<T: Encodable>(_ value: T) throws {
        return try base.encode(value)
    }
}

public struct ExtendedUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    private var parent: Encoder
    private var base: UnkeyedEncodingContainer
    
    public init(_ base: UnkeyedEncodingContainer, parent: Encoder) {
        self.parent = parent
        self.base = base
    }
    
    public var codingPath: [CodingKey] {
        return base.codingPath
    }
    
    public var count: Int {
        return base.count
    }
    
    public mutating func encodeNil() throws {
        try base.encodeNil()
    }
    
    public mutating func encode(_ value: Bool) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Int) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Int8) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Int16) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Int32) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Int64) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: UInt) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: UInt8) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: UInt16) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: UInt32) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: UInt64) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Float) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: Double) throws {
        return try base.encode(value)
    }
    
    public mutating func encode(_ value: String) throws {
        return try base.encode(value)
    }
    
    public mutating func encode<T: Encodable>(_ value: T) throws  {
        return try base.encode(value)
    }
    
    // This is where the magic happens.
    
    public mutating func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey>  {
        return .init(ExtendedKeyedEncodingContainer(base.nestedContainer(keyedBy: keyType), parent: parent))
    }
    
    public mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        return ExtendedUnkeyedEncodingContainer(base.nestedUnkeyedContainer(), parent: parent)
    }
    
    public mutating func superEncoder() -> Encoder {
        return ExtendedEncoder(base.superEncoder())
    }
}

public struct ExtendedKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    private var base: KeyedEncodingContainer<Key>
    private var parent: Encoder
    
    public init(_ base: KeyedEncodingContainer<Key>, parent: Encoder) {
        self.parent = parent
        self.base = base
    }
    
    public var codingPath: [CodingKey] {
        return base.codingPath
    }
    
    public mutating func encodeNil(forKey key: Key) throws {
        return try base.encodeNil(forKey: key)
    }
    
    public mutating func encode(_ value: Bool, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: Int, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: Int8, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: Int16, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: Int32, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: Int64, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: UInt, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: UInt8, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: UInt16, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: UInt32, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: UInt64, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: Float, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: Double, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode(_ value: String, forKey key: Key) throws {
        return try base.encode(value, forKey: key)
    }
    
    public mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        return try base.encode(value, forKey: key)
    }
    
    // This is where the magic happens.
    
    public mutating func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        return .init(ExtendedKeyedEncodingContainer<NestedKey>(base.nestedContainer(keyedBy: keyType, forKey: key), parent: parent))
    }
    
    public mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        return ExtendedUnkeyedEncodingContainer(base.nestedUnkeyedContainer(forKey: key), parent: parent)
    }
    
    public mutating func superEncoder() -> Encoder {
        return ExtendedEncoder(base.superEncoder())
    }
    
    public mutating func superEncoder(forKey key: Key) -> Encoder {
        return ExtendedEncoder(base.superEncoder(forKey: key))
    }
}

// MARK: - Extensions -

// MARK: - Helpers -

// Like AnyHashable, just for Equatable.
public struct AnyEquatable: Equatable {
    private var equate: ((Any, Any) -> Bool)
    private var value: Any
    
    public init<T: Equatable>(_ value: T) {
        func equate(_ x: Any, _ y: Any) -> Bool {
            guard let x = x as? T, let y = y as? T else {
                return false
            }
            return x == y
        }
        self.equate = equate
        self.value = value
    }
    
    public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.equate(lhs.value, rhs.value)
    }
}

// Allows any arbitrary `String` to be used as a coding key.
public struct AnyString: CodingKey, ExpressibleByStringLiteral {
    public var stringValue: String
    public init(stringValue: String) {
        self.stringValue = stringValue
    }
    public var intValue: Int? {
        return nil
    }
    public init?(intValue: Int) {
        return nil
    }
    public init(stringLiteral value: String) {
        self.init(stringValue: value)
    }
}
