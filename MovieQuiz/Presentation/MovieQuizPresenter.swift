import UIKit
final class MovieQuizPresenter {
    
    // MARK: - Private Properties
    
    private var currentQuestionIndex: Int = 0
    
    // MARK: - Internal Properties
    
    let questionsAmount: Int = 10
    
    var isLastQuestion: Bool { currentQuestionIndex == questionsAmount - 1 }
    
    // MARK: - Internal Methods
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
}
