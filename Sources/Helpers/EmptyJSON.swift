//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Swift

internal struct EmptyJSON<T>: Decodable {
    public let value: T?
    
    public init(from decoder: Decoder) throws {
        var accumulator = ErrorAccumulator()
        
        if let singleValueContainer = accumulator.silence(try decoder.singleValueContainer()) {
            if singleValueContainer.decodeNil() {
                value = nil
            } else {
                do {
                    let json = try singleValueContainer.decode(JSON.self)
                    if json.isEmpty {
                        value = nil
                    } else {
                        throw accumulator.accumulated()
                    }
                } catch {
                    accumulator.add(error)
                    throw accumulator.accumulated()
                }
            }
        } else if let unkeyedContainer = accumulator.silence(try decoder.unkeyedContainer()) {
            if unkeyedContainer.isAtEnd {
                value = nil
            } else {
                throw accumulator.accumulated()
            }
        } else if let keyedContainer = accumulator.silence(try decoder.container(keyedBy: JSONCodingKeys.self)) {
            if keyedContainer.allKeys.isEmpty {
                value = nil
            } else {
                throw accumulator.accumulated()
            }
        } else {
            throw accumulator.accumulated()
        }
    }
}
