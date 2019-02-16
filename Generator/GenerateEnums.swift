//
//  GenerateEnums.swift
//  Generator
//
//  Created by pavel.grechikhin on 15.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation
import XcodeKit

class GenerateEnums: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            return
        }
        if invocation.buffer.contentUTI == "com.apple.xcode.strings-text" {
            var localizedKey: [String : String] = [:]
            for (line) in invocation.buffer.lines.enumerated() {
                let lineString = line.element as! String
                var cleanKey: String = ""
                let cleanString = lineString.replacingOccurrences(of: " ", with: "")
                let range = cleanString
                    .range(of: "\".*\"[=]\".*\";", options: .regularExpression, range: nil, locale: nil)
                if range != nil {
                    let rangeKey = cleanString[range!].range(of: "\".*\"[=]", options: .regularExpression, range: nil, locale: nil)
                    if rangeKey != nil {
                        cleanKey = cleanString[rangeKey!].replacingOccurrences(of: "=", with: "").replacingOccurrences(of: "\"", with: "")
                    }
                    var enumKey: String = ""
                    var previousWasUnderscore: Bool = false
                    for char in cleanKey {
                        if char != "_" && char != "-" {
                            if previousWasUnderscore {
                                enumKey += "\(char)".uppercased()
                            } else {
                                enumKey += "\(char)"
                            }
                            previousWasUnderscore = false
                        } else {
                            previousWasUnderscore = true
                        }
                    }
                    localizedKey[cleanKey] = enumKey
                }
            }
            var result:[String] = ["Enum DOCLocalizedKye: String {"]
            print("Enum DOCLocalizedKye: String {")
            for (key, value) in localizedKey {
                print(" case \(value.replacingOccurrences(of: ".", with: "")) = \"\(key)\"")
                result.append("case \(value.replacingOccurrences(of: ".", with: "")) = \"\(key)\"")
            }
            print("\n}")
            result.append("\n}")
            guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
                return
            }
            let targetRange = selection.end.line + 1 ..< selection.end.line + 1 + result.count
            invocation.buffer.lines.insert(result, at: IndexSet(integersIn: targetRange))
        }
        
        completionHandler(nil)
    }
    
}
