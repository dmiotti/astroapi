import Vapor

func routes(_ app: Application) throws {
    app.get { _ in "I‘m healthy!" }
    
    try app.register(collection: SignController())
}
