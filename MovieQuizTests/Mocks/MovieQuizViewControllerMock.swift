import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    
    // MARK: - Main View
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
    }
    
    func show(error model: ErrorViewModel) {
        
    }
    
    // MARK: - Buttons
    
    func changeButtonState(isEnabled: Bool) {
        
    }
    
    // MARK: - Poster
    
    func showPosterBorder(isCorrectAnswer: Bool) {
        
    }
    
    func hidePosterBorder() {
        
    }
    
    // MARK: - Loading Indicator
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
}
