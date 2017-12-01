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
        reminderGroup.get(Reminder.parameter, "user", handler: getUserByReminder)
        reminderGroup.get(Reminder.parameter, "categories", handler: getRemindersCategories)
        
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
        
        if let categories = json[Category.Keypath.categories.rawValue]?.array {
            for catJSON in categories {
                if let category = try Category.find(catJSON[Category.Keypath.id.rawValue]) {
                    try reminder.categories.add(category)
                }
            }
        }
        
        return reminder
    }
    
    func allReminders(_ request: Request) throws -> ResponseRepresentable {
        let list = try Reminder.all()
        return try list.makeJSON()
    }
    
    func getReminder(_ request: Request) throws -> ResponseRepresentable {
        return try request.parameters.next(Reminder.self)
    }
    
    func getUserByReminder(_ request: Request) throws -> ResponseRepresentable {
        let reminder = try request.parameters.next(Reminder.self)
        guard let user = try reminder.user.get() else {
            throw Abort.notFound
        }
        
        return user
    }
    
    func getRemindersCategories(_ request: Request) throws -> ResponseRepresentable {
        let reminder = try request.parameters.next(Reminder.self)
        return try reminder.categories.all().makeJSON()
    }
}
