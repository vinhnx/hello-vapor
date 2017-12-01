import FluentProvider

final class Reminder: Model, ResponseRepresentable {

    public enum Keypath: String {
        case id, title, description, user_id
    }

    // MARK: - Storage

    let storage = Storage()

    // MARK: - Properties

    let title: String
    let description: String
    let userID: Identifier?

    // MARK: - Life cycle

    init(title: String, description: String, user: User) {
        self.title = title
        self.description = description
        self.userID = user.id
    }

    init(row: Row) throws {
        self.title = try row.get(Keypath.title.rawValue)
        self.description = try row.get(Keypath.description.rawValue)
        self.userID = try row.get(Keypath.user_id.rawValue)
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keypath.title.rawValue, self.title)
        try row.set(Keypath.description.rawValue, self.description)
        try row.set(Keypath.user_id.rawValue, self.userID)
        return row
    }
}

extension Reminder {
    var user: Parent<Reminder, User> {
        return parent(id: self.userID)
    }
}

extension Reminder: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { builder in
            builder.id()
            builder.string(Keypath.title.rawValue)
            builder.string(Keypath.description.rawValue)
            // one user has many reminder, a reminder belongs to a user
            builder.parent(User.self)
        })
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
extension Reminder: JSONConvertible {
    convenience init(json: JSON) throws {
        let userID: Identifier = try json.get(Keypath.user_id.rawValue)
        guard let user = try User.find(userID) else {
            throw Abort.badRequest
        }

        try self.init(title: json.get(Keypath.title.rawValue),
                      description: json.get(Keypath.description.rawValue),
                      user: user)
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keypath.id.rawValue, self.id)
        try json.set(Keypath.title.rawValue, self.title)
        try json.set(Keypath.description.rawValue, self.description)
        try json.set(Keypath.user_id.rawValue, self.userID)
        return json
    }
}
