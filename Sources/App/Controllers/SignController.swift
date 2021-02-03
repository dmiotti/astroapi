//
//  MoonSignController.swift
//  
//
//  Created by David Miotti on 03/02/2021.
//

import Foundation
import Vapor
import SwissEphemeris

struct BirthMoment: Content {
    var dt: String
    var tz: String
}

struct MoonSign: Content {
    var sign: String
}

let semaphore = DispatchSemaphore(value: 1)

struct SignController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let sign = routes.grouped("sign")
        sign.get("moon", use: moonSign)
    }
    
    func moonSign(req: Request) throws -> MoonSign {
        let birth = try req.query.decode(BirthMoment.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy'T'HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: birth.tz)
        
        guard let formattedDate = dateFormatter.date(from: birth.dt) else {
            throw Abort(.badRequest)
        }
        
        semaphore.wait()
        defer { semaphore.signal() }
        
        let moonCoordinate = PlanetCoordinate(planet: .moon, date: formattedDate)
        let sign = moonCoordinate.tropicalZodiacPosition.sign
        return MoonSign(sign: sign.formattedShort)
    }
}
