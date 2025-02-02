//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Антон on 02.02.2025.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didReceiveAlert(alert: UIAlertController?)
}
