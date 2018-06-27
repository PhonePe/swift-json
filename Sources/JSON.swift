//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

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
            case .array(let value): do {
                for element in value where element != .null {
                    _ = set.insert(element.unorderedHashValue)
                }
            }
            case .dictionary(let value): do {
                for (key, value) in value where value != .null {
                    _ = set.insert(key)
                    _ = set.insert(value.unorderedHashValue)
                }
            }
        }
        
        return set.hashValue
    }
}

// MARK: - Protocol Implementations -

extension JSON: Codable {
    public func encode(to encoder: Encoder) throws {
        if case .null = self {
            return
        }
        
        switch self {
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
            default:
                return
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
