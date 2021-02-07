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
}
