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
import ValidateKit

struct User {
    let id: Int
    let name: String
    let email: String?
    let age: Int
    let description: String
    let hobbies: [String] = ["a", "b", "c"]
    let phone: String
}

extension User: Validatable {
    
    private static var nameCharacterSet: CharacterSet {
        var characterSet = CharacterSet()
        characterSet.formUnion(.lowercaseLetters)
        characterSet.formUnion(.uppercaseLetters)
        return characterSet
    }
    
    static func conditions() throws -> Conditions<User> {
        var conditions = Conditions(Self.self)
        conditions.add(\.id, "id", .range(0...100) || .range(10000...))
        conditions.add(\.email, "email", .email && !.nil)
        conditions.add(\.age, "age", .range(1...))
        conditions.add(\.name, "name", .count(3...20) && .characters(nameCharacterSet))
        conditions.add(\.description, "description length", .count(30...))
        conditions.add(\.hobbies, "hobbies", !.empty)
        conditions.add(\.phone, "phone", .phoneCharacters)
        return conditions
    }
    
}
