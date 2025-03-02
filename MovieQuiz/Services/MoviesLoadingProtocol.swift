protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<Top250Movies, Error>) -> Void)
}
