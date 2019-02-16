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
    
    let scaner = SwiftScan()
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        if invocation.buffer.contentUTI == "com.apple.xcode.strings-text" {
            var localizedKey: [Pair] = []
            for (line) in invocation.buffer.lines.enumerated() {
                if line.element is String {
                    let lineString = line.element as! String
                    do {
                        let pair = try scaner.scaningStrings(lineString)
                        localizedKey.append(pair)
                    } catch {
                        print("bad string")
                    }
                }
            }
            var result:[String] = ["enum DOCLocalizedKye: String {"]
            for pair in localizedKey {
                if pair.shouldCommented {
                    result.append("//   case \(pair.value) = \"\(pair.key)\"")
                } else {
                    result.append("     case \(pair.value) = \"\(pair.key)\"")
                }
            }
            result.append("\n}")
            let targetRange = invocation.buffer.lines.count ..< invocation.buffer.lines.count + result.count
            invocation.buffer.lines.insert(result, at: IndexSet(integersIn: targetRange))
        }
        
        completionHandler(nil)
    }
    
}
