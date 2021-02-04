import Vapor

// configures application
public func configure(_ app: Application) throws {
    // Cross-Origin Resource Sharing
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)

    // per-route logging
    let routeLogging = RouteLoggingMiddleware(logLevel: .info)

    // default error middleware
    let error = ErrorMiddleware.default(environment: app.environment)
    
    // clear any existing middleware.
    app.middleware = .init()
    app.middleware.use(cors)
    app.middleware.use(routeLogging)
    app.middleware.use(error)

    // register routes
    try routes(app)
}
