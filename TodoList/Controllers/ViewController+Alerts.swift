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
    
    func promptForInput(title: String, message: String? = nil, placeholder: String? = nil) async -> String? {
            return await withCheckedContinuation { continuation in
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                alertController.addTextField { textField in
                    textField.placeholder = placeholder
                }
                
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    let text = alertController.textFields?.first?.text
                    continuation.resume(returning: text)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    continuation.resume(returning: nil)
                }
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
}
