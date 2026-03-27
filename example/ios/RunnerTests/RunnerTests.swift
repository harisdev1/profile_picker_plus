import Flutter
import UIKit
import XCTest

class RunnerTests: XCTestCase {
    func testCanLaunchApp() throws {
        // Verify the Flutter engine initialises without crashing.
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.state == .runningForeground)
    }
}
