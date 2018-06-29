//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Swift

public struct EmptyJSON: Decodable {    
    public init(from decoder: Decoder) throws {
        if let singleValueContainer = try? decoder.singleValueContainer() {
            if singleValueContainer.decodeNil() {
                return
            } else {
                do {
                    let json = try singleValueContainer.decode(JSON.self)
                    if json.isEmpty {
                        return
                    } else {
                        throw JSONRuntimeError.isNotEmpty
                    }
                } catch {
                    throw JSONRuntimeError.isNotEmpty
                }
            }
        } else if let unkeyedContainer = try? decoder.unkeyedContainer() {
            if unkeyedContainer.isAtEnd {
                return
            } else {
                throw JSONRuntimeError.isNotEmpty
            }
        } else if let keyedContainer = try? decoder.container(keyedBy: JSONCodingKeys.self) {
            if keyedContainer.allKeys.isEmpty {
                return
            } else {
                throw JSONRuntimeError.isNotEmpty
            }
        } else {
            throw JSONRuntimeError.isNotEmpty
        }
    }
    
    public func proof<T>() -> T? {
        return nil
    }
}
