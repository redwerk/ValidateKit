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

extension ValidationRule where ValueType: Comparable {
        
    public static func range(_ range: ClosedRange<ValueType>) -> ValidationRule<ValueType> {
        return ValidationRangeRule(min: range.lowerBound, max: range.upperBound).rule()
    }

    public static func range(_ range: PartialRangeThrough<ValueType>) -> ValidationRule<ValueType> {
        return ValidationRangeRule(min: nil, max: range.upperBound).rule()
    }
    
    public static func range(_ range: PartialRangeFrom<ValueType>) -> ValidationRule<ValueType> {
        return ValidationRangeRule(min: range.lowerBound, max: nil).rule()
    }
    
}

private struct ValidationRangeRule<T>: ValidationRuleFactory where T: Comparable {
    
    var info: String {
        if let min = min, let max = max {
            return "between \(min) and \(max)"
        } else if let min = min {
            return "> \(min)"
        } else if let max = max {
            return "< \(max)"
        } else {
            return "valid"
        }
    }
    
    let min: T?
    let max: T?

    init(min: T?, max: T?) {
        self.min = min
        self.max = max
    }

    func validate(_ value: T) throws {
        if let min = min {
            guard value >= min else {
                throw ValidationError.custom(message: "is less than \(min)")
            }
        }

        if let max = max {
            guard value <= max else {
                throw ValidationError.custom(message: "is greater than \(max)")
            }
        }
    }
    
}
