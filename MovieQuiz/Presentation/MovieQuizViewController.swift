import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var questionNumberLabel: UILabel!
    
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var questionTextLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    
    // MARK: - Private Properties
    
    private let headerFont: UIFont? = UIFont(name: "YSDisplay-Medium", size: 20) ?? nil
    private let questionTextFont: UIFont? = UIFont(name: "YSDisplay-Bold", size: 23) ?? nil
    private let buttonFont: UIFont? = UIFont(name: "YSDisplay-Medium", size: 20) ?? nil
    
    private var alertPresenter: AlertPresenter?
    
    private var presenter: MovieQuizPresenter?
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка отображения.
        questionTitleLabel.font = headerFont
        questionNumberLabel.font = headerFont
        
        posterImage.layer.masksToBounds = true
        
        questionTextLabel.font = questionTextFont
        
        noButton.titleLabel?.font = buttonFont
        yesButton.titleLabel?.font = buttonFont
        
        // Инициализация свойств.
        alertPresenter = AlertPresenter(delegate: self)
        
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - IB Actions
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter?.clickedButton(withAnswer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter?.clickedButton(withAnswer: true)
    }
    
    // MARK: - Private Methods
    
    private func changeStateButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    // MARK: - Internal Methods
    
    func showAnswerResult(isCorrect: Bool) {
        posterImage.layer.borderWidth = 8
        posterImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        changeStateButton(isEnabled: false)
        
        presenter?.didAnswer(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            self.posterImage.layer.borderWidth = 0
            self.changeStateButton(isEnabled: true)
            self.presenter?.showNextQuestionOrResults()
        }
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alertModel: AlertModel = AlertModel(
            id: "GameResults",
            title: result.title,
            message: result.text,
            buttonText: result.buttonText) { [weak self] in
                guard let self else { return }
                
                presenter?.restartGame()
            }
        
        alertPresenter?.show(alert: alertModel)
    }
    
    func show(quiz step: QuizStepViewModel) {
        posterImage.image = step.image
        questionTextLabel.text = step.question
        questionNumberLabel.text = step.questionNumber
    }
    
    func showNetworkError(message: String, completion : @escaping (() -> Void)) {
        let alertModel: AlertModel = AlertModel(
            id: "GameError",
            title: "Что-то пошло не так(",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: completion)
        
        alertPresenter?.show(alert: alertModel)
    }
    
    func showLoadingIndicator() {
        changeStateButton(isEnabled: false)
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        changeStateButton(isEnabled: true)
        activityIndicator.stopAnimating()
    }
}

extension MovieQuizViewController: AlertPresenterDelegate {
    func didReceiveAlert(alert: UIAlertController?) {
        guard let alert else { return }

        present(alert, animated: true, completion: nil)
    }
}
