//
//  SecureTasksViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 22.10.2024.
//

import UIKit
import LocalAuthentication

class SecureTasksViewController: UITableViewController {
    struct Const {
        static let cellReuseIdentifier = "secure_task_cell"
    }
        
    @IBAction func addSecureTask(_ sender: UIButton) {
        Task {
            if let taskContent = await promptForInput(title: "New secure task", message: "Enter your task", placeholder: "Task description") {
                print("Secure task: \(taskContent)")
                
                KeychainManager.saveSecureTask(taskContent)
                
                loadSecureTasks()
            } else {
                print("Entering secure task canceled")
            }
        }
    }
    
    private var secureTasks: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await showProtectedTasks()
        }
    }
    
    private func loadSecureTasks() {
        self.secureTasks = KeychainManager.loadSecureTasks() ?? []
        
        tableView.reloadData()
    }
    
    func showProtectedTasks() async {
        let authSuccess = await authenticateUser()
        
        if authSuccess {
            loadSecureTasks()
        } else {
            showErrorAlert(
                title: "Failed to access secure tasks.",
                message: "Please, try again."
            )
        }
    }
    
    func authenticateUser() async -> Bool {
        let context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) 
        else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
            
            return false
        }
        
        do {
            let success = try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Log in to your account")
            
            return success
        } catch let error {
            print(error.localizedDescription)
            
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secureTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let secureTask = secureTasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseIdentifier
        ) as! SecureTaskCellView
        
        cell.config(with: secureTask)
        
        return cell
    }
}
