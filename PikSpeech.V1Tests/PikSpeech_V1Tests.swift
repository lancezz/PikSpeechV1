//
//  PikSpeech_V1UITests.swift
//  PikSpeech.V1UITests
//
//  Created by Lance Zhang on 2018-11-01.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//
//  Copyright © 2018 CMPT 275 Group11: A-team. All rights reserved.
//
//  Change Log:
//      11/04/2018: Created performance test for loading the image name array (Lance Zhang)
import XCTest
@testable import PikSpeech_V1

class PikSpeech_V1Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testStoryboardLoad() {
//
//    }
    func test2() {
        
    }

    func testarrayloadPerformance() {
        // This is an example of a loading array performance test case.
        self.measure {
            Initializer.getAppDataTileData()
            Initializer.getCategoryData()
        }
        
    }
    func test1() {
//        AppDelegate.application(_, application: UIApplication, didFinishLaunchingWithOptions, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        
        
    }

}
}
