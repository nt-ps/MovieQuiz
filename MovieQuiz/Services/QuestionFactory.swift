import Foundation

final class QuestionFactory : QuestionFactoryProtocol {
    
    // MARK: - Internal Properties
    
    weak var delegate: MovieQuizPresenter?
    
    // MARK: - Private Properties
    
    private let moviesLoader: MoviesLoadingProtocol
    private var movies: [MovieDetails] = []
    private var indeces: [Int] = []
    private var wasLastQuestionShown: Bool = false
    
    // MARK: - Initializers
    
    init(moviesLoader: MoviesLoadingProtocol, delegate: MovieQuizPresenter?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // MARK: - Internal Methods
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            let index = getIndex()
            guard let movie = self.movies[safe: index] else { return }

            do {
                let imageData = try movie.getImageData()
                let rating = movie.rating
                let (text, correctAnswer) = generateQuestion(for: rating)
                
                let question = QuizQuestion(
                    image: imageData,
                    text: text,
                    correctAnswer: correctAnswer)
                
                wasLastQuestionShown = true
                
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didReceiveNextQuestion(question: question)
                }
            } catch {
                wasLastQuestionShown = false
                
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadQuestion(with: error)
                }
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let data):
                    self.movies = data.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func getIndex() -> Int {
        if wasLastQuestionShown {
            indeces.removeFirst()
        }
        if indeces.isEmpty {
            indeces = (1..<movies.count).shuffled()
        }
        return indeces.first ?? 0
    }
    
    private func generateQuestion(for rating: Float) -> (String, Bool) {
        let value: Int = (5...9).randomElement() ?? 0
        var text = "Рейтинг этого фильма "
        var answer: Bool
        
        if Bool.random() {
            text += "больше чем \(value)?"
            answer = rating > Float(value)
        } else {
            text += "меньше чем \(value)?"
            answer = rating < Float(value)
        }
        
        return (text, answer)
    }
}
