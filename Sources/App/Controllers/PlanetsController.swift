import Foundation
import Vapor
import SwissEphemeris

struct PlanetsController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let sign = routes.grouped("planets")
        sign.get("moon", use: getMoonSign)
    }
    
    // the Swiss Ephemeris library is not thread safe
    private let semaphore = DispatchSemaphore(value: 1)
    
    // GET /moon returns the Moon‘s sign and degree at a given date
    struct GetMoonSignParams: Content {
        var dt: String
        var tz: Int
    }
    struct MoonSignResponse: Content {
        var sign: String
        var degree: Double
    }
    func getMoonSign(req: Request) throws -> MoonSignResponse {
        let birth = try req.query.decode(GetMoonSignParams.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: birth.tz)
        
        guard let formattedDate = dateFormatter.date(from: birth.dt) else {
            throw Abort(.badRequest)
        }
        
        semaphore.wait()
        defer { semaphore.signal() }
        
        let moonCoordinate = PlanetCoordinate(planet: .moon, date: formattedDate)
        let sign = moonCoordinate.tropicalZodiacPosition.sign
        return MoonSignResponse(sign: sign.formattedShort, degree: moonCoordinate.degree)
    }
}
