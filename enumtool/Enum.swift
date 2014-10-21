//
//  Enum.swift
//  Keychain
//
//  Created by idz on 10/10/14.
//  Copyright (c) 2014 iOS Developer Zone. All rights reserved.
//

import Foundation


var begin = mach_absolute_time()



extension String
{
    /**
    :returns: the shared common prefix of an array of strings
    */
    static func commonPrefix(sa : [String]) -> String
    {
        return sa.reduce(sa[0], combine: { return $1.commonPrefixWithString($0, options:.LiteralSearch) })
    }
    /**
    Strips a prefix from an array of strings
    */
    static func stripPrefix(sa : [String], prefix: String) -> [String]
    {
        return sa.map { $0.hasPrefix(prefix) ? $0.substringFromIndex(prefix.endIndex) : $0 }
    }
    
    /**
    Prepends and appends a string around this string
    */
    func quote(s: String = "\"") -> String
    {
        return s + self + s
    }
    /**
    Splits a string around a given separator
    :param: separator the separator string
    :returns: an array of split strings
    */
    func split(separator: String) -> [String]
    {
        return self.componentsSeparatedByString(separator)
    }
    

    
}



/**
 Parametricly generates Swift code for an enum class
 */
class Enum
{
    var code = Code()
    
    let name : String
    let rawType : String
    let nativeValues : [String]
    let values : [String]
    let commonPrefix : String
    
    init(name : String, rawType: String, nativeValues : String, removeCommonPrefix : Bool)
    {
        self.name = name
        self.rawType = rawType
        self.nativeValues = nativeValues.split(",")
        self.commonPrefix = String.commonPrefix(self.nativeValues)
        self.values = String.stripPrefix(self.nativeValues,
            prefix: self.commonPrefix)
        
    }
    
    let toRawValuesName = "toRawValues"
    let fromRawValuesName = "fromRawValues"
    
//    var rawValues: String
//        {
//            let toRawValuesName = self.toRawValuesName
//            let rawType = self.rawType
//            let commonPrefix = self.commonPrefix
//            
//            var s : String = "static let \(self.toRawValuesName) = [ "
//            let a : [String] = values.map { $0 + ": " + rawType + "(" + commonPrefix + $0 + ")" }
//            //        let a : [String] = values.map { "\($0): \(rawType)(\(commonPrefix)\($0))" }
//            var j = join(", \n", a)
//            
//            s += j
//            s += " ]\n"
//            
//            return s
//    }
    // MARK: - allValuesArray
    /**
    Generates the allValues array
    */
    func emitAllValues() {
        let name = self.name
        let valueList = join(", ", values)
        code.appendln("public static let allValues: [\(name)] = [\(valueList)]")
        
    }
    
    // MARK: - RawRepresentable
    /**
    Generates init?(rawValue: RawType)
    */
    func emitInitRawValue() {
        code.appendln("public init?(rawValue: \(self.rawType)) {").indent()
        for (i, (nv, v)) in enumerate(Zip2(self.nativeValues, self.values)) {
            let ifOrElseIf = (i == 0) ? "if" : "else if"
            code.appendln("\(ifOrElseIf) rawValue == \(self.rawType)(\(nv)) {").indent()
            code.appendln("self = \(v)")
            code.outdent().appendln("}")
        }
        code.appendln("else {").indent()
        code.appendln("return nil")
        code.outdent().appendln("}")
        code.outdent().appendln("}")
    }
    /**
    Generates the rawValue property
    */
    func emitRawValue() {
        code.appendln("public var rawValue: \(self.rawType) {").indent()
        code.appendln("switch self {").indent()
        code = values.reduce(code) { c,v in c.appendln("case \(v): return \(self.rawType)(\(self.commonPrefix)\(v))") }
        code.outdent().appendln("}")
        code.outdent().appendln("}")
    }
    // MARK: - Printable
    /**
    Generates the description property
    */
    func emitDescription()  {
        code.appendln("public var description : String {").indent()
        code.appendln("switch self {")
        code = values.reduce(code) { c,v in c.appendln("case \(v): return \"\(v)\"") }
        code.appendln("}")
        code.outdent().appendln("}")
    }
    /**
    The accumulated code
    */
    var description : String {
        code.clear()
        code.appendln("public enum \(self.name) : RawRepresentable, Printable {").indent()
        code.appendln("case " + join(", ", values))
        code.appendln("")
        emitAllValues()
        code.appendln("")
        emitInitRawValue()
        code.appendln("")
        emitRawValue()
        code.appendln("")
        emitDescription()
        code.outdent().appendln("}")
        return code.description
    }
}
