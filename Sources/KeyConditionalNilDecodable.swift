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
