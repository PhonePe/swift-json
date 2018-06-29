//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

private let debug: Bool = false

public func printIfDebug(_ string: String) {
    if debug {
        print(string)
    }
}

internal func logDecodeError<Container: KeyedDecodingContainerProtocol, T: Decodable>(error: Error, container: Container, type: T.Type, key: Container.Key) {
    
    if case DecodingError.typeMismatch(_, _) = error {
        let json = (try? container.decode(JSON.self, forKey: key).toJSONString()).flatMap({ $0 }) ?? "<<error decoding JSON>>"
        printIfDebug("Expected \(T.self), found \(json)")
    }
}

internal func logDecodeError<Container: SingleValueDecodingContainer, T: Decodable>(error: Error, container: Container, type: T.Type) {
    
    if case DecodingError.typeMismatch(_, _) = error {
        let json = (try? container.decode(JSON.self).toJSONString()).flatMap({ $0 }) ?? "<<error decoding JSON>>"
        printIfDebug("Expected \(T.self), found \(json)")
    }
}
