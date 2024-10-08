//
//  InputAlert.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 08.10.2024.
//

import UIKit

extension UIViewController {
    func showInpulert(title: String, message: String, placeholder: String?, callback: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = placeholder
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            
            if let textInput = textField?.text {
                callback(textInput)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
