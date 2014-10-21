//
//  main.swift
//  et
//
//  Created by idz on 10/19/14.
//  Copyright (c) 2014 iOS Developer Zone. All rights reserved.
//

import Foundation

// MARK: - Command line definition
let cli = CommandLine()

let filePath = StringOption(shortFlag: "i", longFlag: "input", required: true, helpMessage:"Path to input file containing values.")
let name = StringOption(shortFlag: "n", longFlag: "name", required: true, helpMessage: "Name for enum.")
let rawType = StringOption(shortFlag: "r", longFlag: "raw-type", required: true, helpMessage: "Raw type for enum.")
let outputFilePath = StringOption(shortFlag: "o", longFlag: "output", required: false, helpMessage: "Path to output file.")

// MARK: - Command line parse and error check
cli.addOptions(filePath, name, rawType, outputFilePath)
let (success, error) = cli.parse()
if !success {
    println(error!)
    cli.printUsage()
    exit(EX_USAGE)
}

// MARK: - lines
func lines(s: String) -> [String] {
    return split(s, { c in
        c == "\n"
        }, maxSplit: Int.max, allowEmptySlices: false)
}

//MARK: - Calling to Enum
var fileError : NSError?
let s = NSString(contentsOfFile: filePath.value!, encoding: NSUTF8StringEncoding, error: &fileError)
if let fileString = s {
    let valuesArray = lines(fileString)
    let valuesString = join(",", valuesArray)
    let enumTool = Enum(name: name.value!, rawType: rawType.value!, nativeValues: valuesString, removeCommonPrefix: true)
    if let outputFile = outputFilePath.value {
        let code = enumTool.description
        var error: NSError?
        let success = code.writeToFile(outputFile, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
        if(!success)
        {
            println("Failed to write output file \(outputFile) error \(error)")
        }
    }
    else
    {
        println(enumTool.description)
    }
}
else {
    println("Failed to open/read input file \(filePath.value) error \(fileError)")
}



