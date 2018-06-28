//
//  Copyright © 2018 PhonePe. All rights reserved.
//

import ObjectiveC
import Swift

internal struct ObjCClass: CustomStringConvertible {
    var value: AnyClass
    var description: String {
        return String(describing: value)
    }
    
    init(_ value: AnyClass) {
        self.value = value
    }
    
    var superclass: ObjCClass? {
        return class_getSuperclass(value).map(ObjCClass.init)
    }
    
    static func allRegisteredClasses() -> [ObjCClass] {
        let numberOfClasses = Int(objc_getClassList(nil, 0))
        var result: [ObjCClass] = Array(repeating: .init(NSObject.self), count: numberOfClasses)
        
        result.withUnsafeMutableBytes {
            do {
                let classes = AutoreleasingUnsafeMutablePointer<AnyClass>(try $0.baseAddress.unwrap().assumingMemoryBound(to: AnyClass.self))
                objc_getClassList(classes, Int32(numberOfClasses))
            } catch {
                debugPrint("Critical runtime failure")
            }
        }
        
        return result
    }
}

infix operator ~=

internal func == (lhs: ObjCClass, rhs: ObjCClass) -> Bool {
    return lhs.value == rhs.value
}

internal func ~= (lhs: ObjCClass, rhs: ObjCClass) -> Bool {
    let supercls = class_getSuperclass
    
    return
        supercls(lhs.value) == rhs.value ||
        supercls(supercls(lhs.value)) == rhs.value ||
        supercls(supercls(supercls(lhs.value))) == rhs.value ||
        supercls(supercls(supercls(supercls(lhs.value)))) == rhs.value ||
        supercls(supercls(supercls(supercls(supercls(lhs.value))))) == rhs.value
}
