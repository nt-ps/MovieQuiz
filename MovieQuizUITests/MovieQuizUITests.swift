import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testScreenCast() throws {
        app.buttons["Нет"].tap()
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let numberLabel = app.staticTexts["Number"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(numberLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let numberLabel = app.staticTexts["Number"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(numberLabel.label, "2/10")
    }
    
    func testAlert() {
        sleep(2)
        for _ in 0...9 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["GameResults"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 0...9 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["GameResults"]
        XCTAssertTrue(alert.exists)
        
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let numberLabel = app.staticTexts["Number"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(numberLabel.label, "1/10")
    }
}
