//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import Foundation
import Swift

private let debug: Bool = false

extension JSON {
    internal func toJSONStringForDebugging() -> String {
        let encoder = JSONEncoder()
        
        if #available(iOS 11.0, *) {
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        } else {
            encoder.outputFormatting = [.prettyPrinted]
        }
        
        do {
            let data = try encoder.encode(self)
            do {
                return try String(data: data, encoding: .utf8).unwrap()
            } catch {
                return "<<corrupted JSON>>"
            }
        } catch {
            return "<<error encoding JSON>>"
        }
    }
}

extension KeyedDecodingContainerProtocol {
    internal func decodeJSONStringForDebugging(forKey key: Key) -> String {
        return (try? decode(JSON.self, forKey: key).toJSONStringForDebugging()) ?? "<<error decoding JSON for debugging>>"
    }
}

extension SingleValueDecodingContainer {
    internal func decodeJSONStringForDebugging() -> String {
        return (try? decode(JSON.self).toJSONStringForDebugging()) ?? "<<error decoding JSON for debugging>>"
    }
}

extension UnkeyedDecodingContainer {
    internal mutating func decodeJSONStringForDebugging() -> String {
        return (try? decode(JSON.self).toJSONStringForDebugging()) ?? "<<error decoding JSON for debugging>>"
    }
}

extension JSON: CustomDebugStringConvertible {
    public var debugDescription: String {
        return toJSONStringForDebugging()
    }
}

internal func printIfDebug(_ string: String) {
    if debug {
        print(string)
    }
}

internal func logDecodeError<Container: KeyedDecodingContainerProtocol, T: Decodable>(container: Container, type: T.Type, key: Container.Key, error: Error) {
    
    if case DecodingError.typeMismatch(_, _) = error {
        let json = container.decodeJSONStringForDebugging(forKey: key)
        printIfDebug("Error while decoding \(Container.self): expected \(T.self) for \(key.stringValue) but found:\n\(json)")
    }
}

internal func logDecodeError<Container: SingleValueDecodingContainer, T: Decodable>(container: Container, type: T.Type, error: Error) {
    
    if case DecodingError.typeMismatch(_, _) = error {
        let json = container.decodeJSONStringForDebugging()
        printIfDebug("Error while decoding \(Container.self): expected \(T.self) but found:\n\(json)")
    }
}

internal func logDecodeError<Container: UnkeyedDecodingContainer, T: Decodable>(container: Container, type: T.Type, error: Error) {
    
    /*var container = container
    
    if case DecodingError.typeMismatch(_, _) = error {
        let json = (try? container.decode(JSON.self).toJSONString()).flatMap({ $0 }) ?? "<<error decoding JSON>>"
        printIfDebug("Decoding Error: Expected \(T.self), found:\n\(json)")
    }*/
}
