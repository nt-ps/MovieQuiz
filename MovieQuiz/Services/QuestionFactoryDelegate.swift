//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Антон on 02.02.2025.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
