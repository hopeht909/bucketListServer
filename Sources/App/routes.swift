import Vapor


func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("tasks") { req -> [TaskResponse] in
        let data = [
            TaskResponse(createdAt: "Wed Mar 30 2021", objective: "Get this to work"),
            TaskResponse(createdAt: "Wed Mar 30 2021", objective: "Get this to work well")
        ]
        return data
    }
    
    app.post("tasks"){ req -> TaskResponse in
        
        if let movie = try? req.content.decode(TaskResponse.self){
            return movie
        }
        return TaskResponse(createdAt: "error", objective: "400")
    }
}
   
struct TaskResponse: Content {
    var createdAt: String
    var objective: String
}
