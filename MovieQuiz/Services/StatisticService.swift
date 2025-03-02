import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    // MARK: - Internal Properties
    
    var gamesCount: Int {
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    var bestGame: GameResult {
        get {
            let correct: Int = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total: Int = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date: Date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double { totalAnswers > 0 ? 100.0 * Double(correctAnswers) / Double(totalAnswers) : 0.0 }
    
    // MARK: - Private Properties
    
    private let storage: UserDefaults = .standard
    
    private var correctAnswers: Int {
        get { storage.integer(forKey: Keys.correctAnswers.rawValue) }
        set { storage.set(newValue, forKey: Keys.correctAnswers.rawValue) }
    }
    
    private var totalAnswers: Int {
        get { storage.integer(forKey: Keys.totalAnswers.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalAnswers.rawValue) }
    }
    
    // MARK: - Private Enumerations
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case correctAnswers
        case totalAnswers
    }
    
    // MARK: - Internal Methods
    
    func store(result: GameResult) {
        gamesCount += 1
        correctAnswers += result.correct
        totalAnswers += result.total
        
        if result.isBetter(than: bestGame) {
            bestGame = result
        }
    }
}
