//
//  Category.swift
//  App
//
//  Created by Vinh Nguyen on 1/12/17.
//

import FluentProvider

final class Category: Model {
    
    enum Keypath: String {
        case id, categories, name
    }
    
    static let entity = Keypath.categories.rawValue
    
    let storage = Storage()
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(row: Row) throws {
        self.name = try row.get(Keypath.name.rawValue)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keypath.name.rawValue, self.name)
        return row
    }
}

extension Category {
    var reminders: Siblings<Category, Reminder, Pivot<Category, Reminder>> {
        return siblings()
    }
    
    static func addCategory(_ name: String, to reminder: Reminder) throws {
        var category: Category
        if let found = try Category.makeQuery().filter(Keypath.name.rawValue, self.name).first() {
            category = found
        } else {
            category = Category(name: name)
            try category.save()
        }
        
        try category.reminders.add(reminder)
    }
}

extension Category: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Keypath.name.rawValue)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Category: JSONConvertible {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keypath.id.rawValue, self.id)
        try json.set(Keypath.name.rawValue, self.name)
        return json
    }
    
    convenience init(json: JSON) throws {
        try self.init(name: json.get(Keypath.name.rawValue))
    }
}

extension Category: ResponseRepresentable {}
