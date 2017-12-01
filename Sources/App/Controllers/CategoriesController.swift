//
//  CategoriesController.swift
//  App
//
//  Created by Vinh Nguyen on 1/12/17.
//

import Vapor
import FluentProvider

struct CategoriesController {
    func addRoutes(to drop: Droplet) {
        let categoryGroup = drop.grouped("api", "categories")
        
        // GET
        categoryGroup.get(handler: allCategories)
        categoryGroup.get(Category.parameter, handler: getCategories)
        categoryGroup.get(Category.parameter, "reminders", handler: getCategorysReminders)
        
        // POST
        categoryGroup.post("create", handler: createCategory)
    }
    
    func createCategory(_ request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else {
            throw Abort.badRequest
        }
        
        let category = try Category(json: json)
        try category.save()
        return category
    }
    
    func allCategories(_ request: Request) throws -> ResponseRepresentable {
        let categories = try Category.all()
        return try categories.makeJSON()
    }
    
    func getCategories(_ request: Request) throws -> ResponseRepresentable {
        let category = try request.parameters.next(Category.self)
        return category
    }
    
    func getCategorysReminders(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.parameters.next(Category.self)
        return try category.reminders.all().makeJSON()
    }
}
