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
    
    func testlogin() {
        //testing login
        let app = XCUIApplication()
        let validpassword = "testing"
        let validemail = "CMPT275Group11Test@gmail.com"
        
        let userNameTextField =  app.textFields["Email"]
        XCTAssertTrue(userNameTextField.exists)
        userNameTextField.tap()
        userNameTextField.typeText(validemail)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(validpassword)
        
        app.buttons["Log In"].tap()
        
    }
    
    
    func testdrawing() {
        //testing login and drawing
        let app = XCUIApplication()
        let validpassword = "testing"
        let validemail = "CMPT275Group11Test@gmail.com"
        
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
        app/*@START_MENU_TOKEN@*/.buttons["- Drawing"]/*[[".otherElements[\"SettingsView\"].buttons[\"- Drawing\"]",".buttons[\"- Drawing\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeDown()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["LightBlue"].tap()
        element.swipeUp()
        app.buttons["Yellow"].tap()
        element.swipeUp()
        element/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeUp()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["Reset"].tap()
        app.navigationBars["PikSpeech_V1.DrawingView"].buttons["Customization Menu"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Back to Main"]/*[[".otherElements[\"SettingsView\"].buttons[\"Back to Main\"]",".buttons[\"Back to Main\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }
    
    
    func testcoloursize() {
        //testing login and drawing
        let app = XCUIApplication()
        let validpassword = "testing"
        let validemail = "CMPT275Group11Test@gmail.com"
        
        let userNameTextField =  app.textFields["Email"]
        XCTAssertTrue(userNameTextField.exists)
        userNameTextField.tap()
        userNameTextField.typeText(validemail)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(validpassword)
        
        app.buttons["Log In"].tap()
        
        let settingsbuttonButton = app.buttons["SettingsButton"]
        settingsbuttonButton.tap()
        
        let coloursSizesButton = app/*@START_MENU_TOKEN@*/.buttons["- Colours/Sizes"]/*[[".otherElements[\"SettingsView\"].buttons[\"- Colours\/Sizes\"]",".buttons[\"- Colours\/Sizes\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        coloursSizesButton.tap()
        app.buttons["color 1"].tap()
        
        let customizationMenuButton = app.navigationBars["PikSpeech_V1.ColorTileSizeView"].buttons["Customization Menu"]
        customizationMenuButton.tap()
        
        let backToMainButton = app/*@START_MENU_TOKEN@*/.buttons["Back to Main"]/*[[".otherElements[\"SettingsView\"].buttons[\"Back to Main\"]",".buttons[\"Back to Main\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        backToMainButton.tap()
        settingsbuttonButton.tap()
        coloursSizesButton.tap()
        app.buttons["Large"].tap()
        customizationMenuButton.tap()
        backToMainButton.tap()
        
    }
    
    
    func testcameraroll(){
        let app = XCUIApplication()
        let validpassword = "testing"
        let validemail = "CMPT275Group11Test@gmail.com"
        
        let userNameTextField =  app.textFields["Email"]
        XCTAssertTrue(userNameTextField.exists)
        userNameTextField.tap()
        userNameTextField.typeText(validemail)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(validpassword)
        
        app.buttons["Log In"].tap()
        let settingsbuttonButton = app.buttons["SettingsButton"]
        settingsbuttonButton.tap()
        
        let cameraButton = app.buttons["- Camera Roll"]
        cameraButton.tap()

        let customizationMenuButton = app.navigationBars["PikSpeech_V1.UploadView"].buttons["Customization Menu"]
        customizationMenuButton.tap()
        
        let backToMainButton = app/*@START_MENU_TOKEN@*/.buttons["Back to Main"]/*[[".otherElements[\"SettingsView\"].buttons[\"Back to Main\"]",".buttons[\"Back to Main\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        backToMainButton.tap()

        
    }
}
