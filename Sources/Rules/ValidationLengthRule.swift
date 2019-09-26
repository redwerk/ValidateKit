//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Redwerk
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

public final class ValidationLengthRule<T: Collection>: ValidationRule {
    
    private var range: ClosedRange<Int>
    private lazy var errorMessage: String = {
        return "This length of value must be in \(range)"
    }()
    
    public init(_ range: ClosedRange<Int>, errorMessage: String? = nil) {
        self.range = range
        
        if let errorMessage = errorMessage {
            self.errorMessage = errorMessage
        }
    }
    
    public func validate(_ value: Any?, keyPath: AnyKeyPath) -> ValidationResult {
        guard let value = value as? T else {
            return .invalid([
                ValidationKeyPathError(keyPath: keyPath,
                                       validationError: ValidationError.mismatchTypes)
                ])
        }
        
        return range ~= value.count ?
            .valid :
            .invalid([ValidationKeyPathError(keyPath: keyPath, validationError: error)])
    }
    
}

extension ValidationLengthRule {
    
    public var error: ValidationError {
        return .custom(message: errorMessage)
    }
    
}
