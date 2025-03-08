protocol MovieQuizViewControllerProtocol: AnyObject {
    func changeStateButton(isEnabled: Bool)
    
    func highlightPosterBorder(isCorrectAnswer: Bool)
    func removePosterBorder()
    
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func showNetworkError(message: String, completion : @escaping (() -> Void))
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
