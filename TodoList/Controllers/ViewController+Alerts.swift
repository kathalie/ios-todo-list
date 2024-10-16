//
//  InputAlert.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 08.10.2024.
//

import UIKit

extension UIViewController {
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
