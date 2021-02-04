@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHealthy() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.GET, "/") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "I‘m healthy!")
        }
    }
    
    func testMoonSign() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.GET, "/sign/moon?tz=CET&dt=1986-10-16T14:20") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.content.contentType, .plainText)
            XCTAssertEqual(res.body.string, "♈︎", "David Miotti‘s birth moon sign")
        }
        
        try app.test(.GET, "/sign/moon?tz=EST&dt=1989-12-13T05:17") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.content.contentType, .plainText)
            XCTAssertEqual(res.body.string, "♋︎", "Tailor Swift‘s birth moon sign")
        }
        
        try app.test(.GET, "/sign/moon?tz=EST&dt=1964-07-18T21:30") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.content.contentType, .plainText)
            XCTAssertEqual(res.body.string, "♏︎", "Wendy Williams‘s birth moon sign")
        }
        
        try app.test(.GET, "/sign/moon?tz=CET&dt=1947-11-23T23:00") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.content.contentType, .plainText)
            XCTAssertEqual(res.body.string, "♈︎", "Jean-Pierre Foucault‘s birth moon sign")
        }
        
        try app.test(.GET, "/sign/moon?tz=PST&dt=1942-11-27T10:15") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.content.contentType, .plainText)
            XCTAssertEqual(res.body.string, "♋︎", "Jimmi Hendrix‘s birth moon sign")
        }
    }
}
