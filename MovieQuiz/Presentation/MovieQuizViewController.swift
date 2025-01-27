import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var questionNumberLabel: UILabel!
    
    @IBOutlet private weak var posterImage: UIImageView!
    
    @IBOutlet private weak var questionTextLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - Private Properties
    private let headerFont: UIFont? = UIFont(name: "YSDisplay-Medium", size: 20) ?? nil
    private let questionTextFont: UIFont? = UIFont(name: "YSDisplay-Bold", size: 23) ?? nil
    private let buttonFont: UIFont? = UIFont(name: "YSDisplay-Medium", size: 20) ?? nil
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterImage.layer.masksToBounds = true
        
        // Настройка шрифтов (сделано тут из-за того, что установленные
        // шрифты не отображаются в списке шрифтов).
        questionTitleLabel.font = headerFont
        questionNumberLabel.font = headerFont
        
        questionTextLabel.font = questionTextFont
        
        noButton.titleLabel?.font = buttonFont
        yesButton.titleLabel?.font = buttonFont
        
        // Вывод первого вопроса.
        showCurrentQuestion()
    }
    
    // MARK: - IB Actions
    @IBAction private func noButtonClicked(_ sender: Any) {
        let isCorrect: Bool = questions[currentQuestionIndex].correctAnswer == false
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let isCorrect: Bool = questions[currentQuestionIndex].correctAnswer == true
        showAnswerResult(isCorrect: isCorrect)
    }

    // MARK: - Private Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(imageLiteralResourceName: model.image),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }

    private func showCurrentQuestion() {
        let question: QuizQuestion = questions[currentQuestionIndex]
        let questionViewModel: QuizStepViewModel = convert(model: question)
        show(quiz: questionViewModel)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        posterImage.image = step.image
        questionTextLabel.text = step.question
        questionNumberLabel.text = step.questionNumber
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            self?.currentQuestionIndex = 0
            self?.correctAnswers = 0
            self?.showCurrentQuestion()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func showAnswerResult(isCorrect: Bool) {
        posterImage.layer.borderWidth = 8
        posterImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        correctAnswers += isCorrect ? 1 : 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.posterImage.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let quizResult: QuizResultsViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questions.count)",
                buttonText: "Сыграть ещё раз")
            show(quiz: quizResult)
        } else {
            currentQuestionIndex += 1
            showCurrentQuestion()
        }
    }
}

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}
