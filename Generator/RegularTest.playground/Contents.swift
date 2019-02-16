import Foundation


//"cancellation" = "Cancellation"; // Появляется в всплывающем окне при завершении действия на странице
let comment = "//Экран добавления адреса"
let keyWithComment = "\"cancellation_cancel_with_many-special_symbol\" = \"Cancellation\"; // Появляется в всплывающем окне при завершении действия на странице"
let keyWithOutComment = "\"repeat\" = \"Retry\""

print(comment)
print(keyWithComment)
print(keyWithOutComment)

func regular() -> NSRegularExpression {
    let pattern = "\".*\"[=]\".*\";"
    let regularExpression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    return regularExpression
}


let keyWithouSpace = keyWithComment.replacingOccurrences(of: " ", with: "")

let result = regular().firstMatch(in: keyWithouSpace, options: [], range: NSMakeRange(0, keyWithouSpace.count - 1))
if result != nil {
//    NSRange
//    print("\(keyWithouSpace[result])")
}
let a = keyWithouSpace.range(of: "\".*\"[=]", options: .regularExpression, range: nil, locale: nil)
print(keyWithouSpace[a!])
let clean = keyWithouSpace[a!].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "=", with: "")
print(clean)

let removeUnderscoreRange = clean.range(of: ".*[_]", options: .regularExpression, range: nil, locale: nil)

var enumKey: String = ""
var previousWasUnderscore: Bool = false
for char in clean {
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
print(enumKey)
