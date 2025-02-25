import Foundation

final class QuestionFactory : QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    private let moviesLoader: MoviesLoadingProtocol
    private var movies: [MovieDetails] = []
    private var indeces: [Int] = []
    
    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let index = getIndex()
            guard let movie = self.movies[safe: index] else { return }

            let imageData = movie.imageData
            let rating = movie.rating
            
            // TODO: Сделать рандом "больше/меньше чем 2...9".
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.movies = data.items
                    self.indeces = (1..<self.movies.count).shuffled()
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    private func getIndex() -> Int {
        if indeces.isEmpty {
            indeces = (1..<movies.count).shuffled()
        }
        
        return indeces.removeFirst()
    }
}
