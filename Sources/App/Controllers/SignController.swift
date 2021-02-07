//
//  MoonSignController.swift
//  
//
//  Created by David Miotti on 03/02/2021.
//

import Foundation
import Vapor
import SwissEphemeris

struct GetMoonSignParams: Content {
    var dt: String
    var tz: Int
}

struct SignController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let sign = routes.grouped("sign")
        sign.get("moon", use: getMoonSign)
    }
    
    // the Swiss Ephemeris library is not thread safe
    private let semaphore = DispatchSemaphore(value: 1)
    
    func getMoonSign(req: Request) throws -> String {
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
        return sign.formattedShort
    }
}
