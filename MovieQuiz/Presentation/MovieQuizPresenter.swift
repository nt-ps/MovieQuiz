import UIKit
final class MovieQuizPresenter {
    
    // MARK: - Private Properties
    
    private weak var viewController: MovieQuizViewController?
    
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    private var currentQuestionIndex: Int = 0
    
    // MARK: - Internal Properties

    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    var correctAnswers: Int = 0
    
    var isLastQuestion: Bool { currentQuestionIndex == questionsAmount - 1 }
    
    // MARK: - Initializers
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()
        
        loadData()
    }
    
    // MARK: - Private Methods
    
    private func loadData() {
        viewController?.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - Internal Methods
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func clickedButton(withAnswer answer: Bool) {
        guard let currentQuestion else { return }
        
        let isCorrect: Bool = currentQuestion.correctAnswer == answer
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
    
    func didAnswer(isCorrect: Bool) {
        correctAnswers += isCorrect ? 1 : 0;
    }
    
    func showNextQuestionOrResults() {
        if isLastQuestion {
            let result: GameResult = GameResult(
                correct: correctAnswers,
                total: questionsAmount,
                date: Date())
            statisticService?.store(result: result)
            
            var quizResultText: String = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
            if let statisticService {
                quizResultText += "\nКоличество сыгранных квизов: \(statisticService.gamesCount)"
                quizResultText += "\nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
                quizResultText += "\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            }
            
            let quizResult: QuizResultsViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: quizResultText,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: quizResult)
        } else {
            viewController?.showLoadingIndicator()
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.hideLoadingIndicator()
        viewController?.showNetworkError(message: error.localizedDescription) { [weak self] in
            self?.loadData()
        }
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let questionViewModel: QuizStepViewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.viewController?.show(quiz: questionViewModel)
            self.viewController?.hideLoadingIndicator()
        }
    }
    
    func didFailToLoadQuestion(with error: Error) {
        viewController?.hideLoadingIndicator()
        viewController?.showNetworkError(message: error.localizedDescription) { [weak self] in
            self?.questionFactory?.requestNextQuestion()
        }
    }
}
