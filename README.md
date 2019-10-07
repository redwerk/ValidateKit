<p align="center">
   <img width="200" src="https://raw.githubusercontent.com/SvenTiigi/SwiftKit/gh-pages/readMeAssets/SwiftKitLogo.png" alt="ValidateKit Logo">
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat" alt="Swift 4.2">
   </a>
   <a href="http://cocoapods.org/pods/ValidateKit">
      <img src="https://img.shields.io/cocoapods/v/ValidateKit.svg?style=flat" alt="Version">
   </a>
   <a href="http://cocoapods.org/pods/ValidateKit">
      <img src="https://img.shields.io/cocoapods/p/ValidateKit.svg?style=flat" alt="Platform">
   </a>
   <a href="https://github.com/Carthage/Carthage">
      <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage Compatible">
   </a>
   <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM">
   </a>
</p>

# ValidateKit

<p align="center">
ValidateKit is a framework for validating data of model.
</p>

## Features
- [x] Validation rules:
  - [x] Custom rule/throw/value
  - [x] Range (n...m, n..., ...m)
  - [x] Count (n...m, n..., ...m, min, max, empty)
  - [x] Nil
  - [x] CharacterSet (alphanumerics, numerics, phone, custom set)
  - [x] Email
  - [ ] URL
  - [ ] Payment card
  - [ ] Contains
- [x] Operations with rules
  - [x] and `&&`
  - [x] or `||`
  - [x] not `!`
- [x] An open protocol-oriented implementation
- [x] Comprehensive test coverage
- [ ] Code documentation

## Requirements

`iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+`

`Xcode 10.0+`

`Swift 4.2+`

## Example

The example application is the best way to see `ValidateKit` in action. Simply open the `ValidateKit.xcodeproj` and run the `Example` scheme.

## Installation

### CocoaPods

ValidateKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```bash
pod 'ValidateKit'
```
or
```bash
pod 'ValidateKit', :git => 'https://github.com/redwerk/ValidateKit.git', :branch => 'master'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate ValidateKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```bash
github 'redwerk/ValidateKit'
```

Run `carthage update` to build the framework and drag the built `ValidateKit.framework` into your Xcode project. 

On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase” and add the Framework path as mentioned in [Carthage Getting started Step 4, 5 and 6](https://github.com/Carthage/Carthage/blob/master/README.md#if-youre-building-for-ios-tvos-or-watchos)

### Swift Package Manager

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/redwerk/ValidateKit.git", from: "1.0.0")
]
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate ValidateKit into your project manually. Simply drag the `Sources` Folder into your Xcode project.

## Usage

```swift
import Foundation
import ValidateKit

struct User {
  var id: Int
  var name: String
  var email: String?
  var age: Int
  var about: String
  var hobbies: [String] = ["a", "b", "c"]
  var phone: String
}

extension User: Validatable {

  private static var nameCharacterSet: CharacterSet {
    var characterSet = CharacterSet()
    characterSet.formUnion(.lowercaseLetters)
    characterSet.formUnion(.uppercaseLetters)
    return characterSet
  }

  static func conditions() throws -> Conditions<User> {
    var conditions = Conditions(User.self)
    conditions.add(\.id, "id", .range(0...100) || .range(10000...))
    conditions.add(\.email, "email", .email && !.nil)
    conditions.add(\.age, "age", .range(1...))
    conditions.add(\.name, "name", .count(3...20) && .characters(nameCharacterSet))
    conditions.add(\.about, "description length", .count(30...))
    conditions.add(\.hobbies, "hobbies", !.empty)
    conditions.add(\.phone, "phone", .phoneCharacters)
    return conditions
  }
  
}

// ...

let user = User(...)

do {
    try user.validate()
} catch let error {
    print(error.localizedDescription)
}
```

## Contributing
Contributions are very welcome 🙌

## License

```
ValidateKit
Copyright (c) 2019 Redwerk info@redwerk.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
