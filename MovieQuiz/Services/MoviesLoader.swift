import Foundation

struct MoviesLoader: MoviesLoadingProtocol {
    
    private enum LoaderError: Error {
        case emptyArray
    }
    
    // MARK: - NetworkClient
    
    private let networkClient = NetworkClient()
        
    // MARK: - URL
    
    private var top250MoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct top250MoviesUrl")
        }
        return url
    }
    
    // MARK: - Public methods
    func loadMovies(handler: @escaping (Result<Top250Movies, Error>) -> Void) {
        networkClient.fetch(url: top250MoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let top250Movies = try JSONDecoder().decode(Top250Movies.self, from: data)
                    if top250Movies.items.isEmpty {
                        throw LoaderError.emptyArray
                    } else {
                        handler(.success(top250Movies))
                    }
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
        
    }
}
