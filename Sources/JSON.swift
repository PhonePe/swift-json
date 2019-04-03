//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation

public enum JSON {
    case null
    case bool(Bool)
    case number(JSONNumber)
    case string(String)
    case array([JSON])
    case dictionary([String: JSON])
}

// MARK: - Extensions -

extension JSON {
    public var isEmpty: Bool {
        switch self {
        case .null:
            return true
        case .bool(_):
            return false
        case .number(_):
            return false
        case .string(let value):
            return value.isEmpty
        case .array(let value):
            return value.isEmpty
        case .dictionary(let value):
            return value.isEmpty
        }
    }

    public var rawValue: Any? {
        switch self {
        case .null:
            return nil
        case .bool(let value):
            return value
        case .number(let value):
            return value
        case .string(let value):
            return value
        case .array(let value):
            return value.compactMap({ $0.rawValue })
        case .dictionary(let value): do {
            let keysWithValues: [(String, Any)] = value.compactMap {
                if let rawValue = $0.value.rawValue {
                    return ($0.key, rawValue)
                } else {
                    return nil
                }
            }
            return Dictionary(uniqueKeysWithValues: keysWithValues)
            }
        }
    }

    public var unorderedHashValue: Int {
        // Use a set so that the resulting hash is independent of order.
        var set: Set<AnyHashable> = []

        switch self {
        case .null:
            break
        case .bool(let value):
            _ = set.insert(value)
        case .number(let value):
            _ = set.insert(value)
        case .string(let value):
            _ = set.insert(value)
        case .array(let value):
            value.lazy
                .filter { $0 != .null }
                .forEach { _ = set.insert($0.unorderedHashValue) }
        case .dictionary(let value):
            value.lazy
                .filter { $0.value != .null }
                .forEach({
                    _ = set.insert($0.key)
                    _ = set.insert($0.value.unorderedHashValue)
                })
        }

        return set.hashValue
    }
}

extension JSON {
    public var nullValue: Void? {
        get {
            guard case .null = self else {
                return nil
            }
            return ()
        } set {
            if let _ = newValue {
                self = .null
            } else {
                self = nullValue != nil ? .null : self
            }
        }
    }

    public var boolValue: Bool? {
        get {
            guard case let .bool(result) = self else {
                return nil
            }
            return result
        } set {
            if let newValue = newValue {
                self = .bool(newValue)
            } else {
                self = boolValue != nil ? .null : self
            }
        }
    }

    public var numberValue: JSONNumber? {
        get {
            guard case let .number(result) = self else {
                return nil
            }
            return result
        } set {
            if let newValue = newValue {
                self = .number(newValue)
            } else {
                self = numberValue != nil ? .null : self
            }
        }
    }

    public var stringValue: String? {
        get {
            guard case let .string(result) = self else {
                return nil
            }
            return result
        } set {
            if let newValue = newValue {
                self = .string(newValue)
            } else {
                self = stringValue != nil ? .null : self
            }
        }
    }

    public var arrayValue: [JSON]? {
        get {
            guard case let .array(result) = self else {
                return nil
            }
            return result
        } set {
            if let newValue = newValue {
                self = .array(newValue)
            } else {
                self = arrayValue != nil ? .null : self
            }
        }
    }

    public var dictionaryValue: [String: JSON]? {
        get {
            guard case let .dictionary(result) = self else {
                return nil
            }
            return result
        } set {
            if let newValue = newValue {
                self = .dictionary(newValue)
            } else {
                self = dictionaryValue != nil ? .null : self
            }
        }
    }
}

// MARK: - Protocol Implementations -

extension JSON: Codable {
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .null:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        case .bool(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .number(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .string(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .array(let value):
            var container = encoder.unkeyedContainer()
            try value.forEach({ try container.encode($0) })
        case .dictionary(let value):
            var container = encoder.container(keyedBy: JSONCodingKeys.self)
            try value.forEach({ try container.encode($0.value, forKey: .init(stringValue: $0.key)) })
        }
    }

    public init(from decoder: Decoder) throws {
        // JSON can roughly be either of three things: a primitive, an array or a dictionary.
        // Single value containers encode primitives.
        // Unkeyed containers encode sequences (i.e. arrays).
        // Keyed containers encode dictionaries.
        // If it is neither of these three things, it is null.
        if let singleValueContainer = try? decoder.singleValueContainer() {
            var accumulator = ErrorAccumulator()

            if singleValueContainer.decodeNil() {
                self = .null
            } else if let value = accumulator.silence(try singleValueContainer.decode(Bool.self)) {
                self = .bool(value)
            } else if let value = accumulator.silence(try singleValueContainer.decode(JSONNumber.self)) {
                self = .number(value)
            } else if let value = accumulator.silence(try singleValueContainer.decode(String.self)) {
                self = .string(value)
            } else if let value = accumulator.silence(try singleValueContainer.decode([JSON].self)) {
                self = .array(value)
            } else if let value = accumulator.silence(try singleValueContainer.decode([String: JSON].self)) {
                self = .dictionary(value)
            } else {
                throw accumulator.accumulated()
            }

        } else if var unkeyedContainer = try? decoder.unkeyedContainer() {

            var value: [JSON] = []

            unkeyedContainer.count.map({ value.reserveCapacity($0) })

            while !unkeyedContainer.isAtEnd {
                value.append(try unkeyedContainer.decode(JSON.self))
            }

            self = .array(value)

        } else if let keyedContainer = try? decoder.container(keyedBy: JSONCodingKeys.self) {

            var value: [String: JSON] = [:]

            value.reserveCapacity(keyedContainer.allKeys.count)

            for key in keyedContainer.allKeys {
                value[key.stringValue] = try keyedContainer.decode(JSON.self, forKey: key)
            }

            self = .dictionary(value)

        } else {
            self = .null // you ain't got nothin' ¯\_(ツ)_/¯
        }
    }
}

extension JSON: CustomStringConvertible {
    public var description: String {
        return toJSONString(prettyPrint: true) ?? "<<error describing JSON>>"
    }
}

extension JSON: Equatable {
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        switch (lhs, rhs) {
        case (.null, .null):
            return true
        case (.bool(let x), .bool(let y)):
            return x == y
        case (.number(let x), .number(let y)):
            return x == y
        case (.string(let x), .string(let y)):
            return x == y
        case (.array(let x), .array(let y)):
            return x == y
        case (.dictionary(let x), .dictionary(let y)):
            return x == y

        default:
            return false
        }
    }
}

// MARK: - Helpers -

// A helper struct that allows an arbitrary `String` to be used as a coding key.
// Never use this directly.
internal struct JSONCodingKeys: CodingKey {
    var stringValue: String

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}
