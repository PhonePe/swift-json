//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

extension JSONNumber {
    private enum Storage: Codable, Hashable {
        case int(Int)
        case double(Double)
        
        init(from decoder: Decoder) throws {
            var accumulator = ErrorAccumulator()
            let container = try decoder.singleValueContainer()
            
            if let value = accumulator.silence(try container.decode(Int.self)) {
                self = .int(value)
            } else if let value = accumulator.silence(try container.decode(Double.self)) {
                self = .double(value)
            } else {
                throw accumulator.accumulated()
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch self {
                case .int(let value):
                    try container.encode(value)
                case .double(let value):
                    try container.encode(value)
            }
        }
    }
}

public struct JSONNumber: Codable {
    private var storage: Storage
    
    public var rawValue: Any {
        return integerValue ?? doubleValue
    }
    
    public var integerValue: Int? {
        get {
            if case let .int(result) = storage {
                return result
            } else {
                return nil
            }
        }
        
        set {
            self = newValue.map({ JSONNumber($0) }) ?? JSONNumber(Double.signalingNaN)
        }
    }
    
    public var doubleValue: Double {
        get {
            if case let .double(result) = storage {
                return result
            } else {
                return integerValue.map(Double.init) ?? Double.signalingNaN
            }
        }
        
        set {
            self = .init(newValue)
        }
    }
    
    public init(_ value: Int) {
        self.storage = .int(value)
    }
    
    public init(_ value: Double) {
        self.storage = .double(value)
    }
}

extension JSONNumber {
    public init(_ value: Int8) {
        self.init(Int(value))
    }
    
    public init(_ value: Int16) {
        self.init(Int(value))
    }
    
    public init(_ value: Int32) {
        self.init(Int(value))
    }

    public init(_ value: Int64) {
        self.init(Int(value))
    }
    
    public init(_ value: Float) {
        self.init(Double(value))
    }
}

extension JSONNumber
{
    private func map<T>(with other: JSONNumber, using f: ((Int, Int) -> T), _ g: ((Double, Double) -> T)) -> T {
        if let lhs = integerValue, let rhs = other.integerValue {
            return f(lhs, rhs)
        } else {
            return g(doubleValue, other.doubleValue)
        }
    }
    
    private func map(with other: JSONNumber, using f: ((Int, Int) -> Int), _ g: ((Double, Double) -> Double)) -> JSONNumber {
        if let lhs = integerValue, let rhs = other.integerValue {
            return .init(f(lhs, rhs))
        } else {
            return .init(g(doubleValue, other.doubleValue))
        }
    }
    
    private mutating func mutate<T>(with other: JSONNumber, using f: ((inout Int, Int) -> T), _ g: ((inout Double, Double) -> T)) -> T {
        if let _ = integerValue, let rhs = other.integerValue {
            return f(&integerValue!, rhs)
        } else {
            return g(&doubleValue, other.doubleValue)
        }
    }
}

// MARK: - Protocol Implementations -

extension JSONNumber: Comparable {
    public static func < (lhs: JSONNumber, rhs: JSONNumber) -> Bool {
        return lhs.map(with: rhs, using: <, <)
    }
    
    public static func <= (lhs: JSONNumber, rhs: JSONNumber) -> Bool {
        return lhs.map(with: rhs, using: <=, <=)
    }
    
    public static func > (lhs: JSONNumber, rhs: JSONNumber) -> Bool {
        return lhs.map(with: rhs, using: >, >)
    }
    
    public static func >= (lhs: JSONNumber, rhs: JSONNumber) -> Bool {
        return lhs.map(with: rhs, using: >=, >=)
    }
}

extension JSONNumber: CustomStringConvertible {
    public var description: String {
        return String(describing: rawValue)
    }
}

extension JSONNumber: Equatable {
    public static func == (lhs: JSONNumber, rhs: JSONNumber) -> Bool {
        return lhs.map(with: rhs, using: ==, ==)
    }
}

extension JSONNumber: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.init(value)
    }
}

extension JSONNumber: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

extension JSONNumber: Hashable {
    public var hashValue: Int {
        return storage.hashValue
    }
}

extension JSONNumber: Numeric {
    public var magnitude: Double {
        return doubleValue.magnitude
    }
    
    public init?<T: BinaryInteger>(exactly source: T)
    {
        if let value = Int(exactly: source) {
            self.init(value)
        } else if let value = Double(exactly: source) {
            self.init(value)
        } else {
            return nil
        }
    }
    
    public static func + (lhs: JSONNumber, rhs: JSONNumber) -> JSONNumber {
        return lhs.map(with: rhs, using: +, +)
    }
    
    public static func += (lhs: inout JSONNumber, rhs: JSONNumber) {
        return lhs.mutate(with: rhs, using: +=, +=)
    }
    
    public static func - (lhs: JSONNumber, rhs: JSONNumber) -> JSONNumber {
        return lhs.map(with: rhs, using: -, -)
    }
    
    public static func -= (lhs: inout JSONNumber, rhs: JSONNumber) {
        return lhs.mutate(with: rhs, using: -=, -=)
    }
    
    public static func * (lhs: JSONNumber, rhs: JSONNumber) -> JSONNumber {
        return lhs.map(with: rhs, using: *, *)
    }
    
    public static func *= (lhs: inout JSONNumber, rhs: JSONNumber) {
        return lhs.mutate(with: rhs, using: *=, *=)
    }
}
