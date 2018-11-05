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
//      11/04/2018: Created three three major UI tests        (Lance Zhang)
import XCTest

class PikSpeech_V1UITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        
        super.setUp()
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        XCUIDevice.shared.orientation = .landscapeRight
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testSettingsButtonNav() {
        //testing the button on the main page that directs to the Customization Menu
        let app = XCUIApplication()
        let settingsbuttonButton = app.buttons["SettingsButton"]
        let navBar = app.navigationBars["Customization Menu"]
        settingsbuttonButton.tap()
        XCTAssert(navBar.exists, "The settings Navigation Bar does not exist")
        
    }

    func testCameraRollButtonNav(){
        
        let app = XCUIApplication()
        let settingsbuttonButton = app.buttons["SettingsButton"]
        settingsbuttonButton.tap()
        let cameraRollButton = app.buttons["- Camera Roll"]
        cameraRollButton.tap()
        let label = app.staticTexts["Camera Roll"]
        XCTAssert(label.exists, "It's not on the Camera Roll page")
        
        let customizationMenuButton = app.navigationBars["UIView"].buttons["Customization Menu"]
        customizationMenuButton.tap()
        app.buttons["- Drawing"].tap()
        let label1 = app.staticTexts.matching(identifier: "Drawing").firstMatch
        XCTAssert(label1.label == "Drawing", "It's not on the drawing page")
     
        customizationMenuButton.tap()
        app.buttons["     Add Favourites"].tap()
        let label2 = app.staticTexts["Add Favourites"]
        XCTAssert(label2.exists, "It's not on the Add Favourites page")
        customizationMenuButton.tap()
        app.buttons["- Colours"].tap()
        let label3 = app.staticTexts["Color and Size"]
        XCTAssert(label3.exists, "It's not on the color and size page")
        customizationMenuButton.tap()
        app.buttons["- Title Size"].tap()
        XCTAssert(label3.exists, "It's not on the color and size page")
        customizationMenuButton.tap()
        
    
        
    }
    
    func test1(){
        
        
        let app = XCUIApplication()
        let cellsQuery = XCUIApplication().collectionViews.cells
        let catElement = app.otherElements.containing(.button, identifier:"SettingsButton").children(matching: .collectionView).element(boundBy: 2).cells.otherElements.containing(.image, identifier:"cat").element
        XCTAssert(catElement.exists, "It's no cat on this page")
        cellsQuery.otherElements.containing(.staticText, identifier:"cat").element.tap()
        cellsQuery.otherElements.containing(.image, identifier:"Love").element.tap()
        cellsQuery.otherElements.containing(.staticText, identifier:"Love").element.tap()
        let loveElement = app.otherElements.containing(.button, identifier:"SettingsButton").children(matching: .collectionView).element(boundBy: 2).cells.otherElements.containing(.image, identifier:"Love").element
        XCTAssert(loveElement.exists, "It's no love on this page")
        cellsQuery.otherElements.containing(.image, identifier:"Milk").element.tap()
        cellsQuery.otherElements.containing(.staticText, identifier:"Milk").element.tap()
      
        
        let loveinSentence = app.otherElements.containing(.button, identifier:"SettingsButton").children(matching: .collectionView).element(boundBy: 0).cells.otherElements.containing(.image, identifier:"Love").element
        app.buttons["DeletionButton"].tap()
        sleep(1)
        app.buttons["DeletionButton"].tap()
        XCTAssertFalse(loveinSentence.exists, "There is not supposed to have love on this page")

        
        
    }
}
