//
//  MoonSignController.swift
//  
//
//  Created by David Miotti on 03/02/2021.
//

import Foundation
import Vapor
import SwissEphemeris

struct SignController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let sign = routes.grouped("sign")
        sign.get("moon", use: moonSign)
    }
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    struct BirthMoment: Content {
        var dt: String
        var tz: String
    }

    struct MoonSign: Content {
        var sign: String
    }
    
    func moonSign(req: Request) throws -> MoonSign {
        let birth = try req.query.decode(BirthMoment.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
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
