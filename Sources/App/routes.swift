import Vapor
import AsyncHTTPClient

func routes(_ app: Application) throws {
    let taskController = TaskController()
    app.get { req in
        return "It works!"
    }

    app.get("tasks",use: taskController.readAll)
    
    app.post("tasks", use: taskController.create)
    
    app.put("tasks",":id", use: taskController.update)
    
    app.delete("tasks",":id", use: taskController.delete)
    
    
}


struct TaskController{
    
    func create(req: Request) throws -> EventLoopFuture<Tasks> {
        let input = try req.content.decode(Tasks.self)
        let todo = Tasks(id: input.id, objective: input.objective, createdAt: Date())
            return todo.save(on: req.db)
                .map { todo }
        }
    
    func readAll(req: Request) throws -> EventLoopFuture<[Tasks]>{
        return Tasks.query(on: req.db).all()
    }
    
    func update(req: Request) throws -> EventLoopFuture<Tasks> {
            guard let id = req.parameters.get("id", as: UUID.self) else {
                throw Abort(.badRequest)
            }
            let input = try req.content.decode(Tasks.self)
            return Tasks.find(id, on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { task in
                    task.objective = input.objective
                    return task.save(on: req.db)
                        .map { Tasks(id: task.id!, objective: task.objective,  createdAt: task.createdAt) }
                }
        }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
                    throw Abort(.badRequest)
                }
                return Tasks.find(id, on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { $0.delete(on: req.db) }
                    .map { .ok }
    }
    
}
