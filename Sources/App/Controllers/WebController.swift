//
//  WebController.swift
//  App
//
//  Created by Vinh Nguyen on 1/12/17.
//

import Vapor

final class WebController {
    
    private enum Keypath: String {
        case index, page_title, reminders, reminder, user, users, category, categories
    }
    
    private enum Title: String {
        case Home, Users, Categories
    }
    
    let viewRenderer: ViewRenderer
    
    init(viewRenderer: ViewRenderer) {
        self.viewRenderer = viewRenderer
    }
    
    func addRoutes(to drop: Droplet) {
        drop.get(handler: indexHandler)
        drop.get(Keypath.reminders.rawValue, Reminder.parameter, handler: reminderHandler)
        drop.get(Keypath.users.rawValue, handler: allUsersHandler)
        drop.get(Keypath.users.rawValue, User.parameter, handler: userHandler)
        drop.get(Keypath.categories.rawValue, handler: allCategoriesHandler)
        drop.get(Keypath.categories.rawValue, Category.parameter, handler: categoryHandler)
    }
    
    func indexHandler(_ request: Request) throws -> ResponseRepresentable {
        var params: [String: NodeRepresentable] = [:]
        params[Keypath.page_title.rawValue] = Title.Home.rawValue
        params[Keypath.reminders.rawValue] = try Reminder.all()
        params[Keypath.users.rawValue] = try User.all()
        return try viewRenderer.make(Keypath.index.rawValue, params)
    }
    
    func reminderHandler(_ request: Request) throws -> ResponseRepresentable {
        let reminder = try request.parameters.next(Reminder.self)
        
        var params: [String: NodeRepresentable] = [:]
        params[Keypath.page_title.rawValue] = reminder.title
        params[Keypath.reminder.rawValue] = reminder
        params[Keypath.user.rawValue] = try reminder.user.get()
        
        if try reminder.categories.count() > 0 {
            params[Keypath.categories.rawValue] = try reminder.categories.all()
        }
        
        return try viewRenderer.make(Keypath.reminder.rawValue, params)
    }
    
    func allUsersHandler(_ request: Request) throws -> ResponseRepresentable {
        var params: [String: NodeRepresentable] = [:]
        params[Keypath.page_title.rawValue] = Title.Users.rawValue
        params[Keypath.users.rawValue] = try User.all()
        return try viewRenderer.make(Keypath.user.rawValue, params)
    }
    
    func userHandler(_ request: Request) throws -> ResponseRepresentable {
        let user = try request.parameters.next(User.self)
        
        var params: [String: NodeRepresentable] = [:]
        params[Keypath.page_title.rawValue] = user.name
        params[Keypath.user.rawValue] = user
        
        if try user.reminder.count() > 0 {
            params[Keypath.reminders.rawValue] = try user.reminder.all()
        }
        
        return try viewRenderer.make(Keypath.user.rawValue, params)
    }
    
    func allCategoriesHandler(_ request: Request) throws -> ResponseRepresentable {
        var params: [String: NodeRepresentable] = [:]
        params[Keypath.page_title.rawValue] = Title.Categories.rawValue
        params[Keypath.categories.rawValue] = try Category.all()
        return try viewRenderer.make(Keypath.categories.rawValue, params)
    }
    
    func categoryHandler(_ request: Request) throws -> ResponseRepresentable {
        let category = try request.parameters.next(Category.self)
        var params: [String: NodeRepresentable] = [:]
        params[Keypath.page_title.rawValue] = category.name
        params[Keypath.category.rawValue] = category
        
        if try category.reminders.count() > 0 {
            params[Keypath.reminders.rawValue] = try category.reminders.all()
        }
        
        return try viewRenderer.make(Keypath.category.rawValue, params)
    }
}
