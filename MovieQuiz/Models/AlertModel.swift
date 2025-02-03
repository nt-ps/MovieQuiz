//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Антон on 02.02.2025.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)
}
