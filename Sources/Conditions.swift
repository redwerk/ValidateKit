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

public struct Conditions<Model> where Model: Validatable {
    
    private var rules: [ValidationRule<Model>] = []
    
    public init(_ model: Model.Type) {}
    
    public func check(_ model: Model) throws {
        for rule in rules {
            try rule.validate(model)
        }
    }
    
    public mutating func add<ValueType>(_ keyPath: KeyPath<Model, ValueType>,
                                        _ name: String,
                                        _ rule: ValidationRule<ValueType>) {
        add(keyPath, name, rule.info) { (value) in
            try rule.validate(value)
        }
    }
    
    private mutating func add<ValueType>(_ keyPath: KeyPath<Model, ValueType>,
                                         _ name: String,
                                         _ info: String,
                                         _ closure: @escaping (ValueType) throws -> Void) {
        add(info) { (model) in
            try closure(model[keyPath: keyPath])
        }
    }
    
    public mutating func add<ValueType>(value: ValueType,
                                        _ name: String,
                                        _ rule: ValidationRule<ValueType>) {
        add(rule.info) { (_) in
            try rule.validate(value)
        }
    }
    
    public mutating func add(_ info: String,
                             _ closure: @escaping (Model) throws -> Void) {
        let rule: ValidationRule<Model> = .init(info) { (model) in
            try closure(model)
        }
        
        rules.append(rule)
    }
    
}
