//
//  User.swift
//  Run
//
//  Created by Vinh Nguyen on 1/12/17.
//

import FluentProvider

final class User: Model, ResponseRepresentable {
    
    private enum Keypath: String {
        case id, name
    }
    
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

extension User {
    var reminder: Children<User, Reminder> {
        return children()
    }
}

extension User: Preparation {
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

extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(name: json.get(Keypath.name.rawValue))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keypath.name.rawValue, self.name)
        try json.set(Keypath.id.rawValue, self.id)
        return json
    }
}
