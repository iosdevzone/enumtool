//
//  Code.swift
//  Keychain
//
//  Created by idz on 10/17/14.
//  Copyright (c) 2014 iOS Developer Zone. All rights reserved.
//

import Foundation

/**
 Makes generating source code simpler
 */
public class Code {
    var code = ""
    var indentString = "\t"
    var currentIndent = ""
    
    /**
    Clears all code and resets identation level
    */
    public func clear() -> Self {
        code = ""
        currentIndent = ""
        return self
    }
    
    /**
    Increases indentation level
    :returns: this object for chaining
    */
    public func indent() -> Self {
        self.currentIndent += self.indentString
        return self
    }
    
    /**
    Decreases indentation level
    :returns: this object for chaining
    */
    public func outdent() -> Self {
        currentIndent = prefix(currentIndent, countElements(currentIndent) - countElements(indentString))
        return self
    }
    
    /**
    Appends one or more lines of code at current indent level
    :param: s a string containing lines of code
    :returns: this object for chaining
    */
    public func appendln(s: String) -> Self {
        let currentIndent = self.currentIndent
        let lines = split(s, { c in
            c == "\n"
        }, maxSplit: Int.max, allowEmptySlices: true)
        code = reduce(lines, code) { $0 + "\(currentIndent)\($1)\n" }
        return self
    }
    
    /**
    The accumulated code
    */
    var description : String {
        return code
    }
}