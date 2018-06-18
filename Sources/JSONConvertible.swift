//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

internal protocol JSONConvertible {
    func jsonValue() throws -> JSON
}

// MARK: - Implementations -

extension Array: JSONConvertible {
    func jsonValue() throws -> JSON {
        return try .array(map({ try JSON(fromPossibleJSONConvertible: $0) }))
    }
}

extension Bool: JSONConvertible {
    func jsonValue() -> JSON {
        return .bool(self)
    }
}

extension ContiguousArray: JSONConvertible {
    func jsonValue() throws -> JSON {
        return try .array(map({ try JSON(fromPossibleJSONConvertible: $0) }))
    }
}

extension Dictionary: JSONConvertible {
    func jsonValue() throws -> JSON {
        return try .dictionary(
            .init(uniqueKeysWithValues: map {
                (try cast($0.0) as String, try JSON(fromPossibleJSONConvertible: $0.1))
            })
        )
    }
}

extension Double: JSONConvertible {
    func jsonValue() -> JSON {
        return .double(self)
    }
}

extension Float: JSONConvertible {
    func jsonValue() throws -> JSON {
        return .double(try Double(exactly: self).unwrap())
    }
}

extension Int: JSONConvertible {
    func jsonValue() -> JSON {
        return .int(self)
    }
}

extension Int16: JSONConvertible {
    func jsonValue() -> JSON {
        return .int(.init(self))
    }
}

extension Int32: JSONConvertible {
    func jsonValue() -> JSON {
        return .int(.init(self))
    }
}

extension Int64: JSONConvertible {
    func jsonValue() -> JSON {
        return .int(.init(self))
    }
}

extension JSON: JSONConvertible {
    func jsonValue() -> JSON {
        return self
    }
}

extension String: JSONConvertible {
    func jsonValue() -> JSON {
        return .string(self)
    }
}

extension NSArray: JSONConvertible {
    func jsonValue() throws -> JSON {
        return try (self as [AnyObject]).jsonValue()
    }
}

extension NSDictionary: JSONConvertible {
    func jsonValue() throws -> JSON {
        return try (self as Dictionary).jsonValue()
    }
}

extension NSNull: JSONConvertible {
    func jsonValue() -> JSON {
        return .null
    }
}

extension NSNumber: JSONConvertible {
    private func toSwiftNumber() throws -> Any {
        if let value = self as? Double {
            return value
        } else if let value = self as? Float {
            return value
        } else if let value = self as? Int {
            return value
        } else if let value = self as? Int8 {
            return value
        } else if let value = self as? Int16 {
            return value
        } else if let value = self as? Int32 {
            return value
        } else if let value = self as? Int64 {
            return value
        } else if let value = self as? UInt {
            return value
        } else if let value = self as? UInt8 {
            return value
        } else if let value = self as? UInt16 {
            return value
        } else if let value = self as? UInt32 {
            return value
        } else if let value = self as? UInt64 {
            return value
        } else {
            throw RuntimeError.irrepresentableNumber(self)
        }
    }
    
    func jsonValue() throws -> JSON {
        return try JSON(fromPossibleJSONConvertible: try toSwiftNumber())
    }
}

extension NSString: JSONConvertible {
    func jsonValue() -> JSON {
        return (self as String).jsonValue()
    }
}

extension UInt: JSONConvertible {
    func jsonValue() throws -> JSON {
        return .int(try Int(exactly: self).unwrap())
    }
}

extension UInt16: JSONConvertible {
    func jsonValue() throws -> JSON {
        return .int(try Int(exactly: self).unwrap())
    }
}

extension UInt32: JSONConvertible {
    func jsonValue() throws -> JSON {
        return .int(try Int(exactly: self).unwrap())
    }
}

extension UInt64: JSONConvertible {
    func jsonValue() throws -> JSON {
        return .int(try Int(exactly: self).unwrap())
    }
}

// MARK: - Helpers -

extension JSON {
    fileprivate init(fromPossibleJSONConvertible value: Any) throws {
        self = try (try cast(value) as JSONConvertible).jsonValue()
    }
}
