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

import XCTest
@testable import ValidateKit

class ValidateKitTests: XCTestCase {
    
    static var allTests = [
        ("testValidationEmailRule", testValidationEmailRule),
        ("testValidationRangeRule", testValidationRangeRule),
        ("testValidationCountRule", testValidationCountRule),
        ("testValidationCharactersRule", testValidationCharactersRule),
        ("testValidationNilRule", testValidationNilRule),
        ("testOperators", testOperators),
        ("testCustomValue", testCustomValue),
        ("testCustomThrow", testCustomThrow),
        ("testFullModel", testFullModel)
    ]
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testValidationEmailRule() {
        struct Model: Validatable {
            var email: String
            
            static func conditions() throws -> Conditions<Model> {
                var conditions = Conditions(Model.self)
                conditions.add(\.email, "email", .email)
                return conditions
            }
        }
        
        var model = Model(email: "")
        
        // invalid emails
        model.email = "asd"
        XCTAssertThrowsError(try model.validate())
        
        model.email = "asd@asda@.ad"
        XCTAssertThrowsError(try model.validate())
        
        model.email = "bar@foo."
        XCTAssertThrowsError(try model.validate())
        
        model.email = "@microsoft.com"
        XCTAssertThrowsError(try model.validate())
        
        // valid emails
        model.email = "john@apple.com"
        XCTAssertNoThrow(try model.validate())
        
        model.email = "john.appleseed@apple.com"
        XCTAssertNoThrow(try model.validate())
    }
    
    func testValidationRangeRule() {
        struct Model: Validatable {
            var age: Int
            var age2: Int
            var age3: Int
            
            static func conditions() throws -> Conditions<Model> {
                var conditions = Conditions(Model.self)
                conditions.add(\.age, "age", .range(1...100))
                conditions.add(\.age2, "age2", .range(200...))
                conditions.add(\.age3, "age3", .range(...(-5)))
                return conditions
            }
            
            mutating func reset() {
                self.age = 1
                self.age2 = 200
                self.age3 = -10
            }
        }
        
        var model = Model(age: 1, age2: 200, age3: -10)
        model.reset()
        XCTAssertNoThrow(try model.validate())
        
        // age
        model.reset()
        model.age = 1
        XCTAssertNoThrow(try model.validate())
        
        model.age = 50
        XCTAssertNoThrow(try model.validate())
        
        model.age = 100
        XCTAssertNoThrow(try model.validate())
        
        model.age = 0
        XCTAssertThrowsError(try model.validate())
        
        model.age = 101
        XCTAssertThrowsError(try model.validate())
        
        // age2
        model.reset()
        model.age2 = 200
        XCTAssertNoThrow(try model.validate())
        
        model.age2 = 500
        XCTAssertNoThrow(try model.validate())
        
        model.age2 = 10000000
        XCTAssertNoThrow(try model.validate())
        
        model.age2 = 199
        XCTAssertThrowsError(try model.validate())
        
        // age3
        model.reset()
        model.age3 = -100000
        XCTAssertNoThrow(try model.validate())
        
        model.age3 = -10
        XCTAssertNoThrow(try model.validate())
        
        model.age3 = -5
        XCTAssertNoThrow(try model.validate())
        
        model.age3 = 5
        XCTAssertThrowsError(try model.validate())
    }
    
    func testValidationCountRule() {
        struct Model: Validatable {
            var uuid: String = ""
            var uuid2: String = ""
            var uuid3: String = ""
            var labels: [String] = []
            var dict: [String: Int] = [:]
            var set: Set<CGFloat> = []
            
            static func conditions() throws -> Conditions<Model> {
                var conditions = Conditions(Model.self)
                conditions.add(\.uuid, "uuid", !.empty)
                conditions.add(\.uuid2, "uuid2", .min(8))
                conditions.add(\.uuid3, "uuid3", .max(8))
                conditions.add(\.labels, "labels", .count(2...))
                conditions.add(\.dict, "dict", .count(...2))
                conditions.add(\.set, "set", .count(0...2))
                return conditions
            }
            
            mutating func reset() {
                self.uuid = "qqqqq"
                self.uuid2 = "1231231231wqweqwe"
                self.uuid3 = "qwe"
                self.labels = ["a", "b", "c"]
                self.dict = [:]
                self.set = [1.0]
            }
        }
        
        var model = Model(uuid: "", uuid2: "", uuid3: "", labels: [], dict: [:], set: [])
        model.reset()
        XCTAssertNoThrow(try model.validate())
        
        // uuid
        model.reset()
        model.uuid = " "
        XCTAssertNoThrow(try model.validate())
        
        model.uuid = "aaa"
        XCTAssertNoThrow(try model.validate())
        
        model.uuid = ""
        XCTAssertThrowsError(try model.validate())
        
        // uuid2
        model.reset()
        model.uuid2 = "12345678"
        XCTAssertNoThrow(try model.validate())
        
        model.uuid2 = "123sjkdnfisnfisjdnfijdsnfi"
        XCTAssertNoThrow(try model.validate())
        
        model.uuid2 = "1234567"
        XCTAssertThrowsError(try model.validate())
        
        // uuid3
        model.reset()
        model.uuid3 = "12345678"
        XCTAssertNoThrow(try model.validate())
        
        model.uuid3 = " "
        XCTAssertNoThrow(try model.validate())
        
        model.uuid3 = "123456789"
        XCTAssertThrowsError(try model.validate())
        
        // labels
        model.reset()
        model.labels = ["", ""]
        XCTAssertNoThrow(try model.validate())
        
        model.labels = ["a", "b", "c"]
        XCTAssertNoThrow(try model.validate())
        
        model.labels = []
        XCTAssertThrowsError(try model.validate())
        
        model.labels = ["a"]
        XCTAssertThrowsError(try model.validate())
        
        // dict
        model.reset()
        model.dict = [:]
        XCTAssertNoThrow(try model.validate())
        
        model.dict = ["a": 1, "c": 2]
        XCTAssertNoThrow(try model.validate())
        
        
        model.dict = ["a": 1, "b": 2, "c": 3]
        XCTAssertThrowsError(try model.validate())
        
        // set
        model.reset()
        model.set = []
        XCTAssertNoThrow(try model.validate())
        
        model.set = [1.0, 2]
        XCTAssertNoThrow(try model.validate())
        
        
        model.set = [1.0, 2.0, 3.0]
        XCTAssertThrowsError(try model.validate())
    }
    
    func testValidationCharactersRule() {
        struct Model: Validatable {
            var str1: String = ""
            var str2: String = ""
            var str3: String = ""
            var str4: String = ""
            
            static func conditions() throws -> Conditions<Model> {
                var conditions = Conditions(Model.self)
                conditions.add(\.str1, "str1", .alphanumericsCharacters)
                conditions.add(\.str2, "str2", .numericsCharacters)
                conditions.add(\.str3, "str3", .phoneCharacters)
                conditions.add(\.str4, "str4", .characters(.init(charactersIn: "abcdef")))
                return conditions
            }
            
            mutating func reset() {
                self.str1 = "asdads123"
                self.str2 = "123123"
                self.str3 = "+123(123)-213"
                self.str4 = "abc"
            }
        }
        
        var model = Model(str1: "", str2: "", str3: "", str4: "")
        model.reset()
        XCTAssertNoThrow(try model.validate())
        
        // str1
        model.reset()
        model.str1 = ""
        XCTAssertNoThrow(try model.validate())
        
        model.str1 = "zyx"
        XCTAssertNoThrow(try model.validate())
        
        model.str1 = "¬"
        XCTAssertThrowsError(try model.validate())
        
        // str2
        model.reset()
        model.str2 = ""
        XCTAssertNoThrow(try model.validate())
        
        model.str2 = "1234567890"
        XCTAssertNoThrow(try model.validate())
        
        model.str2 = "123c"
        XCTAssertThrowsError(try model.validate())
        
        model.str2 = "q"
        XCTAssertThrowsError(try model.validate())
        
        model.str2 = "12310101010101O1"
        XCTAssertThrowsError(try model.validate())
        
        // str3
        model.reset()
        model.str3 = ""
        XCTAssertNoThrow(try model.validate())
        
        model.str3 = "123( )+-"
        XCTAssertNoThrow(try model.validate())
        
        model.str3 = "p#"
        XCTAssertThrowsError(try model.validate())
        
        // str4
        model.reset()
        model.str4 = ""
        XCTAssertNoThrow(try model.validate())
        
        model.str4 = "abcdef"
        XCTAssertNoThrow(try model.validate())
        
        model.str4 = "abcdefg"
        XCTAssertThrowsError(try model.validate())
    }
    
    func testValidationNilRule() {
        struct Model: Validatable {
            var value1: String?
            var value2: [Int: Int]?
            var value3: [Bool]?
            
            static func conditions() throws -> Conditions<Model> {
                var conditions = Conditions(Model.self)
                conditions.add(\.value1, "value1", .nil)
                conditions.add(\.value2, "value2", .nil)
                conditions.add(\.value3, "value3", !.nil)
                return conditions
            }
            
            mutating func reset() {
                self.value1 = nil
                self.value2 = nil
                self.value3 = [true, false]
            }
        }
        
        var model = Model(value1: nil, value2: nil, value3: nil)
        model.reset()
        XCTAssertNoThrow(try model.validate())
        
        // value1
        model.reset()
        model.value1 = nil
        XCTAssertNoThrow(try model.validate())
        
        model.value1 = ""
        XCTAssertThrowsError(try model.validate())
        
        // value2
        model.reset()
        model.value2 = nil
        XCTAssertNoThrow(try model.validate())
        
        model.value2 = [:]
        XCTAssertThrowsError(try model.validate())
        
        // value3
        model.reset()
        model.value3 = []
        XCTAssertNoThrow(try model.validate())
        
        model.value3 = nil
        XCTAssertThrowsError(try model.validate())
    }
    
    func testOperators() {
        struct Model: Validatable {
            var value1: String?
            var value2: String?
            
            static func conditions() throws -> Conditions<Model> {
                var conditions = Conditions(Model.self)
                conditions.add(\.value1, "value1", .email || .nil)
                conditions.add(\.value1, "value1", .nil || .email)
                conditions.add(\.value2, "value2", .email && !.nil)
                conditions.add(\.value2, "value2", !.nil && .email)
                conditions.add(\.value2, "value2", .email && !.nil && .count(5...))
                return conditions
            }
            
            mutating func reset() {
                self.value1 = nil
                self.value2 = "foor@bar.com"
            }
        }
        
        var model = Model(value1: nil, value2: "aaa@bbb.ccc")
        model.reset()
        XCTAssertNoThrow(try model.validate())
        
        // value1
        model.reset()
        model.value1 = nil
        XCTAssertNoThrow(try model.validate())
        
        model.value1 = "bbb@wwww.as"
        XCTAssertNoThrow(try model.validate())
        
        model.value1 = ""
        XCTAssertThrowsError(try model.validate())
        
        // value2
        model.reset()
        model.value2 = nil
        XCTAssertThrowsError(try model.validate())
        
        model.value2 = "bbb@wwww.as"
        XCTAssertNoThrow(try model.validate())
        
        model.value2 = ""
        XCTAssertThrowsError(try model.validate())
    }
    
    func testCustomValue() {
        struct Model: Validatable {
            
            static func conditions() throws -> Conditions<Model> {
                var conditions = Conditions(Model.self)
                conditions.add(value: "foo@bar.com", "custom value", .email)
                return conditions
            }
        }
        
        let model = Model()
        XCTAssertNoThrow(try model.validate())
    }
    
    func testCustomThrow() {
        struct Model: Validatable {
            var startDate: Date
            var endDate: Date
            
            static func conditions() throws -> Conditions<Model> {
                var conditions = Conditions(Model.self)
                conditions.add("valid dates") { (model) in
                    if model.endDate < model.startDate {
                        throw ValidationError.custom(message: "startDate must be less endDate")
                    }
                }
                return conditions
            }
            
            mutating func reset() {
                self.startDate = Date()
                self.endDate = Date()
            }
        }
        
        var model = Model(startDate: Date(), endDate: Date())
        XCTAssertNoThrow(try model.validate())
        
        model.reset()
        model.startDate = Date()
        model.endDate = model.startDate.addingTimeInterval(100)
        XCTAssertNoThrow(try model.validate())
        
        model.reset()
        model.startDate = Date()
        model.endDate = model.startDate.addingTimeInterval(-100)
        XCTAssertThrowsError(try model.validate())
    }
    
    func testFullModel() {
        let user = User(id: 99,
                        name: "abc",
                        email: "blabla@gmail.com",
                        age: 13,
                        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
                        hobbies: ["sport"],
                        phone: "+380 (96) 174-45-45")
        
        do {
            try user.validate()
        } catch let error {
            print(error.localizedDescription)
        }
        
        XCTAssertNoThrow(try user.validate())
    }
    
}
