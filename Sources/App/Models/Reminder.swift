import FluentProvider

final class Reminder: Model {
    
    private enum Keypath: String {
        case title, description
    }
    
    // MARK: - Storage

    let storage = Storage()
    
    // MARK: - Properties

    let title: String
    let description: String
    
    // MARK: - Life cycle
    
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


