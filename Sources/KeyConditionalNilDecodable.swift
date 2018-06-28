//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

// Decodes as `nil` if certain mandatory keys are not present.
public protocol KeyConditionalNilDecodable: Decodable {
    static var mandatoryCodingKeys: [CodingKey] { get }
}

extension Decodable {
    public static var mandatoryCodingKeysIfAny: [CodingKey] {
        return (self as? KeyConditionalNilDecodable.Type)?.mandatoryCodingKeys ?? []
    }
}

internal struct KeyConditionalNilDecodableProxy<T: KeyConditionalNilDecodable>
{
    public let value: T?
    
    public init(from decoder: Decoder) throws
    {
        do {
            self.value = try T(from: decoder)
        } catch {
            if case DecodingError.keyNotFound(let key, _) = error {
                if T.mandatoryCodingKeys.contains(where: { $0.stringValue == key.stringValue }) {
                    self.value = nil
                } else {
                    throw error
                }
            } else {
                throw error
            }
        }
    }
}
