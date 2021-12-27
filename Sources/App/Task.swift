//
//  File.swift
//  
//
//  Created by admin on 23/05/1443 AH.
//

import Foundation
import Vapor
import Fluent
import FluentSQLiteDriver
import FluentSQL

final class Tasks: Content, Model, Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tasks")
            .id()
            .field("objective", .string)
            .field("createdAt", .date)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tasks").delete()
    }
    
    static let schema = "tasks"
    
    @ID(key: .id)
    var id : UUID?
    @Field(key: "objective")
    var objective: String
    @Field(key: "createdAt")
    var createdAt: Date?
    
    init() {
    }
    
    init(id: UUID? = nil, objective: String, createdAt: Date?) {
            self.id = id
            self.objective = objective
            self.createdAt = createdAt
        }
}
