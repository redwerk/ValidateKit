//
//  Event.swift
//  Example
//
//  Created by divbyzero on 07/10/2019.
//  Copyright © 2019 Redwerk. All rights reserved.
//

import Foundation
import ValidateKit

struct Event {
    let id: String
    let startDate: Date
    var endDate: Date
    let subject: String
    let author: String?
    let cost: Int
}

extension Event: Validatable {
    
    static func conditions() throws -> Conditions<Event> {
        var conditions = Conditions(Event.self)
        
        var idCharacterSet: CharacterSet = .alphanumerics
        idCharacterSet.formUnion(CharacterSet(charactersIn: "-"))
        conditions.add(\.id, "uuid", .characters(idCharacterSet) && .count(36...36))
        conditions.add(\.author, "author", .nil || .count(3...))
        conditions.add("dates") { (event) in
            if event.startDate > event.endDate {
                throw ValidationError.custom(message: "Invalid start or end date.")
            }
        }
        conditions.add(\.cost, "duration", .range(0...))
        conditions.add(\.author, "author", .nil || .count(3...))
        return conditions
    }
    
}
