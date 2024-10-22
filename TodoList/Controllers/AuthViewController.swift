//
//  AuthViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 22.10.2024.
//

import UIKit

class AuthViewController: UIViewController {
    struct Const {
        static let toMainScreen = "to_main_screen"
    }
    
    @IBOutlet private weak var usernameTextField: UITextField!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBAction private func login(_ sender: UIButton) {
        guard 
            let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            self.showErrorAlert(title: "Failed to login.", message: "Creadentials must not be empty.")
            
            return
        }
        
        Task {
            await authorizeUser(username: username, password: password)
        }
    }
    
    private func authorizeUser(username: String, password: String) async {
        let success = await AuthManager.shared.login(username: username, password: password)
        
        print(success ? "Logined successfully" : "Failed to login")
        
        if success {
            KeychainManager.saveCredentials(username: username, password: password)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Const.toMainScreen, sender: nil)
            }
        } else {
            self.showErrorAlert(title: "Failed to login.", message: "Login data is incorrect. Please, try again.")
            
            print("Login failed")
        }
    }
}
