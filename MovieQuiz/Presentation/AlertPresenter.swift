//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Антон on 02.02.2025.
//

import UIKit

class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    func show(alert model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.completion)
        
        alert.addAction(action)
        
        delegate?.didReceiveAlert(alert: alert)
    }
}
