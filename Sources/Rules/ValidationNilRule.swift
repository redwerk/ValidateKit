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

public protocol ValidationOptional {
    associatedtype WrappedType
    var wrapped: WrappedType? { get }
}

extension Optional: ValidationOptional {
    public typealias WrappedType = Wrapped
    
    public var wrapped: Wrapped? {
        switch self {
        case .none:
            return nil
        case .some(let wrapped):
            return wrapped
        }
    }
}

extension ValidationRule where ValueType: ValidationOptional {
    
    public static var `nil`: ValidationRule<ValueType.WrappedType?> {
        return ValidationNilRule(ValueType.WrappedType.self).rule()
    }
    
}

private struct ValidationNilRule<T>: ValidationRuleFactory {
    
    var info: String = "is nil"

    init(_ type: T.Type) {}

    func validate(_ value: T?) throws {
        if value != nil {
            throw ValidationError.custom(message: "is not nil")
        }
    }
    
}
