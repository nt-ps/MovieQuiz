import UIKit
final class MovieQuizPresenter {
    
    // MARK: - Private Properties
    
    private var currentQuestionIndex: Int = 0
    
    // MARK: - Internal Properties
    
    weak var viewController: MovieQuizViewController?
    
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    
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
    
    func clickedButton(withAnswer answer: Bool) {
        guard let currentQuestion else { return }
        
        let isCorrect: Bool = currentQuestion.correctAnswer == answer
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
}
