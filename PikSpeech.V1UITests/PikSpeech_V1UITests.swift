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
//      11/19/2018: Created major UI testcases for version 2 (Sheel Soneji)
//      11/19/2018: Reworked and created testcases for version 3 (Sheel Soneji)
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
    
    func testcustomization() {
        // testing complete ui
        let app = XCUIApplication()
        let validpassword = "testing"
        let validemail = "CMPT275Group11Test@gmail.com"
        let validpin = "1"
        
        let userNameTextField =  app.textFields["Email"]
        XCTAssertTrue(userNameTextField.exists)
        userNameTextField.tap()
        userNameTextField.typeText(validemail)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(validpassword)
        
        app.buttons["Log In"].tap()
        
        app.buttons["SettingsButton"].tap()
        let parentalControlAlert = app.alerts["Parental Control"]
        let pinHereTextField = parentalControlAlert.collectionViews.textFields["Pin here"]
        pinHereTextField.tap()
        pinHereTextField.typeText(validpin)
        app.alerts["Parental Control"].buttons["Confirm"].tap()

        let coloursSizesButton = app/*@START_MENU_TOKEN@*/.buttons["- Colours/Sizes"]/*[[".otherElements[\"SettingsView\"].buttons[\"- Colours\/Sizes\"]",".buttons[\"- Colours\/Sizes\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        coloursSizesButton.tap()
        app.buttons["Ancient Yellow"].tap()
        app.buttons["Large"].tap()
        let backButton = app.buttons["< Back"]
        backButton.tap()
        let backToMainButton = app/*@START_MENU_TOKEN@*/.buttons["Back to Main"]/*[[".otherElements[\"SettingsView\"].buttons[\"Back to Main\"]",".buttons[\"Back to Main\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        backToMainButton.tap()
        
    }
    
    func testnavigation() {
        
        let app = XCUIApplication()
        let validpassword = "testing"
        let validemail = "CMPT275Group11Test@gmail.com"
        let validpin = "1"
        
        let userNameTextField =  app.textFields["Email"]
        XCTAssertTrue(userNameTextField.exists)
        userNameTextField.tap()
        userNameTextField.typeText(validemail)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(validpassword)
        
        app.buttons["Log In"].tap()
        
        app.buttons["SettingsButton"].tap()
        let parentalControlAlert = app.alerts["Parental Control"]
        let pinHereTextField = parentalControlAlert.collectionViews.textFields["Pin here"]
        pinHereTextField.tap()
        pinHereTextField.typeText(validpin)
        app.alerts["Parental Control"].buttons["Confirm"].tap()

        
        let backButton = app.buttons["< Back"]
        app/*@START_MENU_TOKEN@*/.buttons["- Colours/Sizes"]/*[[".otherElements[\"SettingsView\"].buttons[\"- Colours\/Sizes\"]",".buttons[\"- Colours\/Sizes\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Add Favourites"]/*[[".otherElements[\"SettingsView\"].buttons[\"Add Favourites\"]",".buttons[\"Add Favourites\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["- Drawing"]/*[[".otherElements[\"SettingsView\"].buttons[\"- Drawing\"]",".buttons[\"- Drawing\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["- Camera Roll"]/*[[".otherElements[\"SettingsView\"].buttons[\"- Camera Roll\"]",".buttons[\"- Camera Roll\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Back to Main"]/*[[".otherElements[\"SettingsView\"].buttons[\"Back to Main\"]",".buttons[\"Back to Main\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
       
    }
    
    
    func testdrawing() {
        //testing login and drawing
        let app = XCUIApplication()
        let validpassword = "testing"
        let validemail = "CMPT275Group11Test@gmail.com"
        let validpin = "1"
        
        let userNameTextField =  app.textFields["Email"]
        XCTAssertTrue(userNameTextField.exists)
        userNameTextField.tap()
        userNameTextField.typeText(validemail)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(validpassword)
        
        app.buttons["Log In"].tap()
        
        app.buttons["SettingsButton"].tap()
        let parentalControlAlert = app.alerts["Parental Control"]
        let pinHereTextField = parentalControlAlert.collectionViews.textFields["Pin here"]
        pinHereTextField.tap()
        pinHereTextField.typeText(validpin)
        app.alerts["Parental Control"].buttons["Confirm"].tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["- Drawing"]/*[[".otherElements[\"SettingsView\"].buttons[\"- Drawing\"]",".buttons[\"- Drawing\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 2).children(matching: .other).element
        
        
        element/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["DarkGreen"].tap()
        element/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeUp()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        element/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeUp()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["DarkOrange"].tap()
        element/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        element/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let resetButton = app.buttons["Reset"]
        resetButton.tap()

        let backButton = app.buttons["< Back"]
        backButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Back to Main"]/*[[".otherElements[\"SettingsView\"].buttons[\"Back to Main\"]",".buttons[\"Back to Main\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
    }
    
    
    func teststatspage(){
        
        let app = XCUIApplication()
        let validpassword = "testing"
        let validemail = "CMPT275Group11Test@gmail.com"
        let validpin = "1"
        
        let userNameTextField =  app.textFields["Email"]
        XCTAssertTrue(userNameTextField.exists)
        userNameTextField.tap()
        userNameTextField.typeText(validemail)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(validpassword)
        
        app.buttons["Log In"].tap()
        
        app.buttons["SettingsButton"].tap()
        let parentalControlAlert = app.alerts["Parental Control"]
        let pinHereTextField = parentalControlAlert.collectionViews.textFields["Pin here"]
        pinHereTextField.tap()
        pinHereTextField.typeText(validpin)
        app.alerts["Parental Control"].buttons["Confirm"].tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["See Your Stats"]/*[[".otherElements[\"SettingsView\"].buttons[\"See Your Stats\"]",".buttons[\"See Your Stats\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let monthButton = app/*@START_MENU_TOKEN@*/.buttons["Month"]/*[[".segmentedControls.buttons[\"Month\"]",".buttons[\"Month\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        monthButton.tap()
        
        let weekButton = app/*@START_MENU_TOKEN@*/.buttons["Week"]/*[[".segmentedControls.buttons[\"Week\"]",".buttons[\"Week\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        weekButton.tap()
        
        monthButton.tap()
        weekButton.tap()
    
        app.buttons["< Back"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Back to Main"]/*[[".otherElements[\"SettingsView\"].buttons[\"Back to Main\"]",".buttons[\"Back to Main\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        
    }
    
    
}
