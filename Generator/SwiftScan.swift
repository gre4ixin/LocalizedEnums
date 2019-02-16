//
//  SwiftScan.swift
//  Generator
//
//  Created by Pavel Grechikhin on 17/02/2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation

class SwiftScan: NSObject {
    
    enum ScaningError: Error {
        case badString
    }
    
    func scaningStrings(_ line: String) throws -> Pair {
        var cleanKey: String = ""
        let cleanString = line.replacingOccurrences(of: " ", with: "")
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
                if char != "_" && char != "-" && char != "/" {
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
            if !checkForScpecialSymbols(cleanKey) {
                throw ScaningError.badString
            }
            
            return checkLineLength(cleanKey, value: cleanValue(enumKey))
        }
        throw ScaningError.badString
    }
    
    private func checkForScpecialSymbols(_ string: String) -> Bool {
        let firstCharacter = String(string.first!)
        if Int(firstCharacter) != nil {
            return false
        }
        if string.contains("$") || string.contains("%") || string.contains("•") {
            return false
        }
        return true
    }
    
    private func cleanValue(_ value: String) -> String {
        var cleanResult = ""
        let cleanValue = value.replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: "!", with: "")
            .replacingOccurrences(of: ",", with: "")
        
        if cleanValue == "operator" {
            cleanResult = "`operator`"
        } else if cleanValue == "repeat" {
            cleanResult = "`repeat`"
        } else {
            cleanResult = cleanValue
        }
        return cleanResult
    }
    
    private func checkLineLength(_ key: String, value: String) -> Pair {
        var pair = Pair(key: key, value: value)
        if value.count > 200 || key.count > 200 {
            pair.shouldCommented = true
        }
        return pair
    }
}

struct Pair {
    var key: String
    var value: String
    var shouldCommented: Bool = false
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
