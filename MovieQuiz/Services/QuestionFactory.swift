import Foundation

final class QuestionFactory : QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    private let moviesLoader: MoviesLoadingProtocol
    
    private var movies: [MovieDetails] = []
    
    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            // TODO: Будет лучше, если фильмы не будут повторяться в рамках одной игры. Можно либо удалять показанные фильмы из массива (но хранить их в другом, чтобы потом вернуть обратно), либо сразу генерировать массив из 10 различных индексов для одной игры (это будет проще).
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            let imageData = movie.imageData
            
            // TODO: Тут по уроку, но лучше делать перевод во float сразу при чтении данных. И можно попробовать делать так с картинкой (String -> Data).
            let rating = Float(movie.rating) ?? 0
            
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
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
