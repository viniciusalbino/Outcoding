//
//  OutcodingUITestsLaunchTests.swift
//  OutcodingUITests
//
//  Created by Vinicius Albino on 08/04/24.
//

import XCTest

final class OutcodingUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        takeScreenshot(name: "LaunchScreen")
        
        
    }
    
    func takeScreenshot(name: String) {
        let fullScreenshot = XCUIScreen.main.screenshot()
        
        let screenshot = XCTAttachment(uniformTypeIdentifier: "public.png", name: "Screenshot-\(name)-\(UIDevice.current.name).png", payload: fullScreenshot.pngRepresentation, userInfo: nil)
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
}
