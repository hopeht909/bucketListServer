import Vapor
import Fluent
import FluentSQLiteDriver
// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(Tasks())
    try app.autoMigrate().wait()
    // register routes
    try routes(app)
}
