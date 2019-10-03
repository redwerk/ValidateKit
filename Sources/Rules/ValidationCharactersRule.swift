//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Redwerk info@redwerk.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

extension ValidationRule where ValueType == String {
    
    public static var alphanumericsCharacters: ValidationRule<String> {
        return characters(.alphanumerics)
    }
    
    public static var numericsCharacters: ValidationRule<String> {
        return characters(CharacterSet(charactersIn: "0123456789"))
    }
    
    public static var phoneCharacters: ValidationRule<String> {
        return characters(CharacterSet(charactersIn: "+-0123456789() "))
    }
    
    public static func characters(_ characterSet: CharacterSet) -> ValidationRule<String> {
        return ValidationCharactersRule(characterSet).rule()
    }
    
}

private struct ValidationCharactersRule: ValidationRuleFactory {
    
    var info: String {
        // TODO: list of characters
        return "in set of characters"
    }

    private let characterSet: CharacterSet
    private var invertedCharacterSet: CharacterSet {
        return characterSet.inverted
    }

    init(_ characterSet: CharacterSet) {
        self.characterSet = characterSet
    }

    func validate(_ value: String) throws {
        if let characterRange = value.rangeOfCharacter(from: invertedCharacterSet) {
            throw ValidationError.custom(message: "string contains unavailable character `\(value[characterRange])`")
        }
    }
    
}
