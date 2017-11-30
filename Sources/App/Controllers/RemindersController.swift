//
//  RemindersController.swift
//  remindersPackageDescription
//
//  Created by Vinh Nguyen on 30/11/17.
//

import Vapor
import FluentProvider

struct RemindersController {
    
    // MARK: - Router
    
    func addRoutes(to drop: Droplet) {
        let reminderGroup = drop.grouped("api", "reminders")
        
        // GET
        // NOTE: by not specifying a path for this route, it will simple be registered to the root path of the route group
        reminderGroup.get(handler: allReminders)
        
        reminderGroup.get(Reminder.parameter, handler: getReminder)
        
        // POST
        reminderGroup.post("create", handler: createReminder)
    }
    
    // MARK: - Public
    
    func createReminder(_ request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else {
            throw Abort.badRequest
        }
        
        let reminder = try Reminder(json: json) // create new reminder instance
        try reminder.save() // save to DB
        return reminder
    }
    
    func allReminders(_ request: Request) throws -> ResponseRepresentable {
        let list = try Reminder.all()
        return try list.makeJSON()
    }
    
    func getReminder(_ request: Request) throws -> ResponseRepresentable {
        return try request.parameters.next(Reminder.self)
    }
}
