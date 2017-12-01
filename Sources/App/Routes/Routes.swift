import Vapor

extension Droplet {
    func setupRoutes() throws {
        let remindersController = RemindersController()
        remindersController.addRoutes(to: self)

        let usersController = UsersController()
        usersController.addRoutes(to: self)
    }
}
