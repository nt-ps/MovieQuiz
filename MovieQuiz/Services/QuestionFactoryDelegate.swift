protocol QuestionFactoryDelegate: AnyObject {
    
    // MARK: - Loading data
    
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    
    // MARK: - Loading question
    
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didFailToLoadQuestion(with error: Error)
}
