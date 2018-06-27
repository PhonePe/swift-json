//
// Copyright (c) Vatsal Manot
//

import JSON
import Foundation

class Animal: Codable, DecodableSupertype
{
    private enum CodingKeys: String, CodingKey {
        case name
    }

    public let name: String
    
    public init(name: String)
    {
        self.name = name
    }
    
    public typealias TypeIdentifier = String
    
    public class func typeIdentifier() -> Animal.TypeIdentifier {
        return "animal"
    }
    
    public class func decodeTypeIdentifier(from decoder: Decoder) throws -> String {
        return try decoder.container(keyedBy: CodingKeys.self).decode(forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(forKey: .name)
    }
}

class Bunny: Animal
{
    private enum CodingKeys: String, CodingKey {
        case cuteness
    }

    public let cuteness: Float
    
    public init(cuteness: Float)
    {
        self.cuteness = cuteness
        
        super.init(name: "bunny")
    }

    public override class func typeIdentifier() -> Animal.TypeIdentifier {
        return "bunny"
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cuteness, forKey: .cuteness)
        try super.encode(to: encoder)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cuteness = try container.decode(forKey: .cuteness)
        try super.init(from: decoder)
    }
}

class Cheetah: Animal
{
    private enum CodingKeys: String, CodingKey {
        case aggressiveness
    }
    
    public let aggressiveness: Float
    
    public init(aggressiveness: Float)
    {
        self.aggressiveness = aggressiveness
        
        super.init(name: "cheetah")
    }
    
    public override class func typeIdentifier() -> Animal.TypeIdentifier {
        return "cheetah"
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(aggressiveness, forKey: .aggressiveness)
        try super.encode(to: encoder)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        aggressiveness = try container.decode(forKey: .aggressiveness)
        try super.init(from: decoder)
    }
}

print("test")


struct Ark: Codable
{
    let animals: [Animal]
}

var ark = Ark(animals: [Cheetah(aggressiveness: 0.5), Bunny(cuteness: 0.8), Cheetah(aggressiveness: 1.0)])

var jsonEncoder = JSONEncoder()

var data = try! jsonEncoder.encode(ark)

try JSONDecoder().decode(Ark.self, from: data).animals.forEach({ print(type(of: $0)) })
try JSONDecoder().extendedDecode(Ark.self, from: data).animals.forEach({ print(type(of: $0)) })
