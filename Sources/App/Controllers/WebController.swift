//
//  WebController.swift
//  App
//
//  Created by Vinh Nguyen on 1/12/17.
//

import Vapor

final class WebController {
    
    private enum Keypath: String {
        case index
    }
    
    let viewRenderer: ViewRenderer
    
    init(viewRenderer: ViewRenderer) {
        self.viewRenderer = viewRenderer
    }
    
    func addRoutes(to drop: Droplet) {
        drop.get(handler: indexHandler)
    }
    
    func indexHandler(_ request: Request) throws -> ResponseRepresentable {
        return try viewRenderer.make("index")
    }
}
