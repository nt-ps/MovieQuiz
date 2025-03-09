import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyImageData = Data()
        let questionText = "Question Text";
        let question = QuizQuestion(image: emptyImageData, text: questionText, correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, questionText)
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
} 
