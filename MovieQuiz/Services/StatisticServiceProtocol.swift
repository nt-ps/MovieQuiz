//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Антон on 03.02.2025.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(result: GameResult)
}
