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

internal func logDecodeError<Container: KeyedDecodingContainerProtocol, T: Decodable>(container: Container, type: T.Type, key: Container.Key, error: Error) {
    
    if case DecodingError.typeMismatch(_, _) = error {
        let json = (try? container.decode(JSON.self, forKey: key).toJSONString()).flatMap({ $0 }) ?? "<<error decoding JSON>>"
        printIfDebug("Decoding Error: Expected \(T.self) for \(key.stringValue), found:\n\(json)")
    }
}

internal func logDecodeError<Container: SingleValueDecodingContainer, T: Decodable>(container: Container, type: T.Type, error: Error) {
    
    if case DecodingError.typeMismatch(_, _) = error {
        let json = (try? container.decode(JSON.self).toJSONString()).flatMap({ $0 }) ?? "<<error decoding JSON>>"
        printIfDebug("Decoding Error: Expected \(T.self), found:\n\(json)")
    }
}

internal func logDecodeError<Container: UnkeyedDecodingContainer, T: Decodable>(container: Container, type: T.Type, error: Error) {
    
    /*var container = container
    
    if case DecodingError.typeMismatch(_, _) = error {
        let json = (try? container.decode(JSON.self).toJSONString()).flatMap({ $0 }) ?? "<<error decoding JSON>>"
        printIfDebug("Decoding Error: Expected \(T.self), found:\n\(json)")
    }*/
}
