//
//  UsersController.swift
//  Run
//
//  Created by Vinh Nguyen on 1/12/17.
//

import Vapor
import FluentProvider

struct UsersController {
    func addRoutes(to drop: Droplet) {
        let usersGroup = drop.grouped("api", "users")
        
        // GET
        usersGroup.get(handler: allUsers)
        usersGroup.get(User.parameter, handler: getUser)
        usersGroup.get(User.parameter, "reminder", handler: getUsersReminders)
        
        // POST
        usersGroup.post("create", handler: createUser)
    }
    
    func createUser(_ request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else {
            throw Abort.badRequest
        }
        
        let user = try User(json: json)
        try user.save()
        return user
    }
    
    func allUsers(_ request: Request) throws -> ResponseRepresentable {
        let users = try User.all()
        return try users.makeJSON()
    }
    
    func getUser(_ request: Request) throws -> ResponseRepresentable {
        return try request.parameters.next(User.self)
    }
    
    func getUsersReminders(_ request: Request) throws -> ResponseRepresentable {
        let user = try request.parameters.next(User.self)
        return try user.reminder.all().makeJSON()
    }
}
