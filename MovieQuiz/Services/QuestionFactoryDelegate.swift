protocol QuestionFactoryDelegate: AnyObject {
    
    // MARK: - Loading Data
    
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    
    // MARK: - Loading Question
    
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didFailToLoadQuestion(with error: Error)
}
