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

public final class ValidationEmailRule<T: Collection>: ValidationRule {
    
    private lazy var errorMessage: String = {
        return "Must be a valid email address"
    }()
    private let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    public init(errorMessage: String? = nil) {
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
        
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: value) ?
            .valid :
            .invalid([ValidationKeyPathError(keyPath: keyPath, validationError: error)])
    }
    
}

extension ValidationEmailRule {
    
    public var error: ValidationError {
        return .custom(message: errorMessage)
    }
    
}
