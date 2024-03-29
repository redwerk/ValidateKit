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

import UIKit
import ValidateKit

// MARK: - ViewController

/// The ViewController
class ViewController: UIViewController {

    // MARK: Properties
    
    /// The Label
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "🚀\nValidateKit\nExample"
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    // MARK: View-Lifecycle
    
    /// View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        var event = Event(id: UUID.init().uuidString,
                          startDate: Date(), endDate: Date().addingTimeInterval(60 * 60),
                          subject: "Temp Event",
                          author: nil,
                          cost: 100)
        
        do {
            try event.validate()
        } catch let error {
            print(error)
        }
        
        // check `Invalid start or end date` error
        
        event.endDate = Date().addingTimeInterval(-200)
        
        do {
            try event.validate()
        } catch let error {
            print(error)
        }
    }
    
    /// LoadView
    override func loadView() {
        self.view = self.label
    }

}
