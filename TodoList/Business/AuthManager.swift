//
//  AuthManager.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 22.10.2024.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    func login(username: String, password: String) async -> Bool {
        let url = URL(string: "http://localhost:8080/auth")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(Int.self, from: data)
            
            print(response)
            
            if response == 200 {
                return true
            }
        } catch {
            print("Login request failed: \(error)")
        }
        
        return false
    }
}
