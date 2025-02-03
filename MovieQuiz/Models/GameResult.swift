//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Антон on 03.02.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetter(than result: GameResult) -> Bool { correct > result.correct }
}
