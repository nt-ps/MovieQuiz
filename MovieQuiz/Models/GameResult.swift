import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetter(than result: GameResult) -> Bool { correct > result.correct }
}
