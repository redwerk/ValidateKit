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

// MARK: - AND

public func &&<T> (lhs: ValidationRule<T>, rhs: ValidationRule<T>) -> ValidationRule<T> {
    return ValidationAndRule(lhs, rhs).rule()
}

private struct ValidationAndRule<T>: ValidationRuleFactory {
    
    var info: String {
        return "\(leftRule.info) and is \(rightRule.info)"
    }

    let leftRule: ValidationRule<T>
    let rightRule: ValidationRule<T>

    init(_ leftRule: ValidationRule<T>, _ rightRule: ValidationRule<T>) {
        self.leftRule = leftRule
        self.rightRule = rightRule
    }

    func validate(_ value: T) throws {
        do {
            try leftRule.validate(value)
            try rightRule.validate(value)
        } catch let error as ValidationError {
            throw ValidationError.custom(message: error.errorDescription ?? "")
        }
    }
    
}

// MARK: - OR

public func ||<T> (lhs: ValidationRule<T>, rhs: ValidationRule<T>) -> ValidationRule<T> {
    return ValidationOrRule(lhs, rhs).rule()
}

private struct ValidationOrRule<T>: ValidationRuleFactory {
    
    var info: String {
        return "\(leftRule.info) or is \(rightRule.info)"
    }

    let leftRule: ValidationRule<T>
    let rightRule: ValidationRule<T>

    init(_ leftRule: ValidationRule<T>, _ rightRule: ValidationRule<T>) {
        self.leftRule = leftRule
        self.rightRule = rightRule
    }

    func validate(_ value: T) throws {
        do {
            try leftRule.validate(value)
        } catch let letfRuleError as ValidationError {
            do {
                try rightRule.validate(value)
            } catch let rightRuleError as ValidationError {
                let message = "\(letfRuleError.errorDescription ?? "") and \(rightRuleError.errorDescription ?? "")"
                throw ValidationError.custom(message: message)
            }
        }
    }
    
}

// MARK: - NOT

public prefix func !<T> (rhs: ValidationRule<T>) -> ValidationRule<T> {
    return ValidationNotRule(rhs).rule()
}

private struct ValidationNotRule<T>: ValidationRuleFactory {
    
    var info: String {
        return "not \(rule.info)"
    }

    let rule: ValidationRule<T>

    init(_ rule: ValidationRule<T>) {
        self.rule = rule
    }

    func validate(_ value: T) throws {
        var validationError: ValidationError?
        
        do {
            try rule.validate(value)
        } catch let error as ValidationError {
            validationError = error
        }
        
        if validationError == nil {
            throw ValidationError.custom(message: "is \(rule.info)")
        }
    }
    
}

// MARK: - NIL (AND/OR)

public func &&<T> (lhs: ValidationRule<T>, rhs: ValidationRule<T?>) -> ValidationRule<T?> {
    return ValidationNilOperatorRule(lhs).rule() && rhs
}

public func &&<T> (lhs: ValidationRule<T?>, rhs: ValidationRule<T>) -> ValidationRule<T?> {
    return lhs && ValidationNilOperatorRule(rhs).rule()
}

public func ||<T> (lhs: ValidationRule<T>, rhs: ValidationRule<T?>) -> ValidationRule<T?> {
    return ValidationNilOperatorRule(lhs).rule() || rhs
}

public func ||<T> (lhs: ValidationRule<T?>, rhs: ValidationRule<T>) -> ValidationRule<T?> {
    return lhs || ValidationNilOperatorRule(rhs).rule()
}

private struct ValidationNilOperatorRule<T>: ValidationRuleFactory {
    
    var info: String {
        return "not \(rule.info)"
    }
    
    let rule: ValidationRule<T>

    init(_ rule: ValidationRule<T>) {
        self.rule = rule
    }
    
    func validate(_ value: T?) throws {
        guard let value = value else {
            return
        }
        
        try rule.validate(value)
    }
    
}
