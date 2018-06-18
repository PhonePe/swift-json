//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import MachO
import ObjectiveC
import Swift

// MARK: - Opaque Protocols -

public protocol opaque_ProxyDecodable {
    func opaque_getValue() -> Any
}

public protocol opaque_DecodableSupertype: Decodable {
    static var covariants: [Any.Type] { get }
    static func opaque_ProxyDecodableType() -> (opaque_ProxyDecodable & Decodable).Type
}

extension opaque_DecodableSupertype where Self: DecodableSupertype {
    public static func opaque_ProxyDecodableType() -> (opaque_ProxyDecodable & Decodable).Type {
        return SupertypeProxyDecodable<Self>.self
    }
}

// MARK: - Protocols -

public protocol DecodableSupertype: opaque_DecodableSupertype {
    
    associatedtype TypeIdentifier: Decodable, Equatable
    
    static var covariants: [Any.Type] { get }
    
    static func typeIdentifier() -> TypeIdentifier
    static func decodeTypeIdentifier(from _: Decoder) throws -> TypeIdentifier
}

// MARK: - Proxy Decodables -

public struct SupertypeProxyDecodable<T: DecodableSupertype>: Decodable, opaque_ProxyDecodable {
    public var value: T
    
    public func opaque_getValue() -> Any {
        return value
    }
    
    public init(from decoder: Decoder) throws {
        let typeIdentifier = try T.decodeTypeIdentifier(from: decoder)
        let type = try T.covariants.lazy.map({ try cast($0) as T.Type }).filter({ $0.typeIdentifier() == typeIdentifier }).first.unwrap()
        value = try type.init(from: decoder)
    }
}

// MARK: - Helpers -

private var registeredClasses = ObjCClass.allRegisteredClasses()
private var covariantMap: [ObjectIdentifier: [Any.Type]] = [:]

extension DecodableSupertype where Self: AnyObject {
    
    private static func fetchCovariants() -> [Any.Type] {
        // Routine to filter through all registered classes.
        let getSubclasses: (() -> [Any.Type]) = {
            return registeredClasses.lazy.filter({ $0 ~= ObjCClass(Self.self) }).map({ $0.value })
        }
        
        // Filter through all registered classes.
        let results = getSubclasses()
        
        // Re-fetch all registered classes, to account for dynamic reloads.
        if results.isEmpty {
            registeredClasses = ObjCClass.allRegisteredClasses()
            return getSubclasses()
        } else {
            return results
        }
    }
    
    // WARNING: Do not use if app dynamic loads/unloads dylibs.
    public static var covariants: [Any.Type] {
        if let result = covariantMap[.init(self)] {
            return result
        } else {
            let result = fetchCovariants()
            covariantMap[.init(self)] = result
            return result
        }
    }
}
