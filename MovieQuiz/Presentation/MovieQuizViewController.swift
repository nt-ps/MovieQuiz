import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var questionNumberLabel: UILabel!
    
    @IBOutlet private weak var posterImage: UIImageView!
    
    @IBOutlet private weak var questionTextLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    
    private let headerFont: UIFont? = UIFont(name: "YSDisplay-Medium", size: 20) ?? nil
    private let questionTextFont: UIFont? = UIFont(name: "YSDisplay-Bold", size: 23) ?? nil
    private let buttonFont: UIFont? = UIFont(name: "YSDisplay-Medium", size: 20) ?? nil
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenter?
    
    private var statisticService: StatisticServiceProtocol?
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterImage.layer.masksToBounds = true
        
        // Настройка шрифтов.
        questionTitleLabel.font = headerFont
        questionNumberLabel.font = headerFont
        
        questionTextLabel.font = questionTextFont
        
        noButton.titleLabel?.font = buttonFont
        yesButton.titleLabel?.font = buttonFont
        
        // Инициализация свойств.
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        let alertPresenter: AlertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        statisticService = StatisticService()
        
        // Загрузка данных.
        loadData()
    }
    
    // MARK: - IB Actions
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion else { return }
        let isCorrect: Bool = currentQuestion.correctAnswer == false
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion else { return }
        let isCorrect: Bool = currentQuestion.correctAnswer == true
        showAnswerResult(isCorrect: isCorrect)
    }
    
    // MARK: - Private Methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showCurrentQuestion() {
        questionFactory?.requestNextQuestion()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        posterImage.image = step.image
        questionTextLabel.text = step.question
        questionNumberLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel: AlertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText) { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.showCurrentQuestion()
            }
        
        alertPresenter?.show(alert: alertModel)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        posterImage.layer.borderWidth = 8
        posterImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        changeStateButton(isEnabled: false)
        
        correctAnswers += isCorrect ? 1 : 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.posterImage.layer.borderWidth = 0
            self?.changeStateButton(isEnabled: true)
            
            self?.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let result: GameResult = GameResult(
                correct: correctAnswers,
                total: questionsAmount,
                date: Date())
            statisticService?.store(result: result)
            
            var quizResultText: String = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
            if let statisticService = statisticService {
                quizResultText += "\nКоличество сыгранных квизов: \(statisticService.gamesCount)"
                quizResultText += "\nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
                quizResultText += "\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            }
            
            let quizResult: QuizResultsViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: quizResultText,
                buttonText: "Сыграть ещё раз")
            show(quiz: quizResult)
        } else {
            currentQuestionIndex += 1
            showCurrentQuestion()
        }
    }
    
    private func changeStateButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    private func showLoadingIndicator() {
        // TODO: По-хорошему, activityIndicator нужно выровнять по области изображения, и отображать тогда, когда данные или конкретное изображение подгружается. И ранее загруженные изображения можно попробовать кэшировать (сделать приватные поля для юрла и изображения, и одно публичное поле, где по гету будет проверка есть изображение в кэше или нет. Если есть - вернуть его, если нет - попробовать подгрузить.
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        let alertModel: AlertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                self?.loadData()
            }
        
        alertPresenter?.show(alert: alertModel)
    }
    
    private func loadData() {
        showLoadingIndicator()
        questionFactory?.loadData()
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let questionViewModel: QuizStepViewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: questionViewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        showCurrentQuestion()
    }

    func didFailToLoadData(with error: Error) {
        hideLoadingIndicator()
        showNetworkError(message: error.localizedDescription)
    }
}

extension MovieQuizViewController: AlertPresenterDelegate {
    func didReceiveAlert(alert: UIAlertController?) {
        guard let alert else { return }
        
        present(alert, animated: true, completion: nil)
    }
}
