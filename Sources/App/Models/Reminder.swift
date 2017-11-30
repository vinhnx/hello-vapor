import FluentProvider

final class Reminder: Model {

    public enum Keypath: String {
        case id, title, description
    }

    // MARK: - Storage

    let storage = Storage()

    // MARK: - Properties

    let title: String
    let description: String

    // MARK: - Life cycle

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    init(row: Row) throws {
        self.title = try row.get(Keypath.title.rawValue)
        self.description = try row.get(Keypath.description.rawValue)
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keypath.title.rawValue, self.title)
        try row.set(Keypath.description.rawValue, self.description)
        return row
    }
}

extension Reminder: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { creator in
            creator.id()
            creator.string(Keypath.title.rawValue)
            creator.string(Keypath.description.rawValue)
        })
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
extension Reminder: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(title: json.get(Keypath.title.rawValue),
                      description: json.get(Keypath.description.rawValue))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keypath.id.rawValue, self.id)
        try json.set(Keypath.title.rawValue, self.title)
        try json.set(Keypath.description.rawValue, self.description)
        return json
    }
}

extension Reminder: ResponseRepresentable {}
