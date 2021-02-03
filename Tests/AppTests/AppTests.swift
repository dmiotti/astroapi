@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHealthy() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.GET, "/", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "I‘m healthy!")
        })
    }
    
    func testMoonSign() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.GET, "/sign/moon?tz=CET&dt=16/10/1986T14:20", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.content.contentType, .json)
            let content = try res.content.decode(MoonSign.self)
            XCTAssertEqual(content.sign, "♈︎", "David Miotti‘s birth moon sign")
        })
        
        try app.test(.GET, "/sign/moon?tz=EST&dt=13/12/1989T05:17", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.content.contentType, .json)
            let content = try res.content.decode(MoonSign.self)
            XCTAssertEqual(content.sign, "♋︎", "Tailor Swift‘s birth moon sign")
        })
        
        try app.test(.GET, "/sign/moon?tz=EST&dt=18/07/1964T21:30", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.content.contentType, .json)
            let content = try res.content.decode(MoonSign.self)
            XCTAssertEqual(content.sign, "♏︎", "Wendy Williams‘s birth moon sign")
        })
        
        try app.test(.GET, "/sign/moon?tz=CET&dt=23/11/1947T23:00", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.content.contentType, .json)
            let content = try res.content.decode(MoonSign.self)
            XCTAssertEqual(content.sign, "♈︎", "Jean-Pierre Foucault‘s birth moon sign")
        })
        
        try app.test(.GET, "/sign/moon?tz=PST&dt=27/11/1942T10:15", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.content.contentType, .json)
            let content = try res.content.decode(MoonSign.self)
            XCTAssertEqual(content.sign, "♋︎", "Jimmi Hendrix‘s birth moon sign")
        })
    }
}