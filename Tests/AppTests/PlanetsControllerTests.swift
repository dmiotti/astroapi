@testable import App
import XCTVapor

final class PlanetsControllerTests: XCTestCase {
    func testMoonSign() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        struct GetMoonSignTestCase {
            var dt: String
            var tz: Int
            var result: PlanetsController.MoonSignResponse
        }
        
        let testCases: [GetMoonSignTestCase] = [
            // David Miotti
            GetMoonSignTestCase(
                dt: "1986-10-16T14:20", tz: 3600,
                result: PlanetsController.MoonSignResponse(sign: "♈︎", degree: 8.1674625375063883)),
            
            // Tailor Swift
            GetMoonSignTestCase(
                dt: "1989-12-13T05:17", tz: -18000,
                result: PlanetsController.MoonSignResponse(sign: "♋︎", degree: 91.49739690324421)),
            
            // Wendy Williams
            GetMoonSignTestCase(
                dt: "1964-07-18T21:30", tz: -18000,
                result: PlanetsController.MoonSignResponse(sign: "♏︎", degree: 235.57237562484974)),
            
            // Jean-Pierre Foucault
            GetMoonSignTestCase(
                dt: "1947-11-23T23:00", tz: 3600,
                result: PlanetsController.MoonSignResponse(sign: "♈︎", degree: 4.818616405857553)),
            
            // Jimi Hendrix
            GetMoonSignTestCase(
                dt: "1942-11-27T10:15", tz: -25200,
                result: PlanetsController.MoonSignResponse(sign: "♋︎", degree: 118.07964004616278)),
        ]
        
        for testCase in testCases {
            try app.test(.GET, "/planets/moon?tz=\(testCase.tz)&dt=\(testCase.dt)") { res in
                XCTAssertEqual(res.status, .ok)
                XCTAssertEqual(res.content.contentType, .json)
                let content = try res.content.decode(PlanetsController.MoonSignResponse.self)
                XCTAssertEqual(content.sign, testCase.result.sign)
                XCTAssertEqual(content.degree, testCase.result.degree)
            }
        }
    }
}
