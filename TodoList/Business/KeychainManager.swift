//
//  KeychainManager.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 22.10.2024.
//

import Foundation
import Security

class KeychainManager {
    struct Const {
        static let usernameField = "username"
        static let passwordField = "password"
    }
    
    static func saveCredentials(username: String, password: String) {
        let usernameData = username.data(using: .utf8)!
        let passwordData = password.data(using: .utf8)!
        
        deleteCredentials()
        
        let usernameQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Const.usernameField,
            kSecValueData as String: usernameData
        ]
        SecItemAdd(usernameQuery as CFDictionary, nil)
        
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Const.passwordField,
            kSecValueData as String: passwordData
        ]
        SecItemAdd(passwordQuery as CFDictionary, nil)
    }

    static func getCredentials() -> (username: String?, password: String?) {
        let usernameQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Const.usernameField,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var usernameItem: AnyObject?
        SecItemCopyMatching(usernameQuery as CFDictionary, &usernameItem)
        
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Const.passwordField,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var passwordItem: AnyObject?
        SecItemCopyMatching(passwordQuery as CFDictionary, &passwordItem)
        
        if let usernameData = usernameItem as? Data,
           let passwordData = passwordItem as? Data {
            let username = String(data: usernameData, encoding: .utf8)
            let password = String(data: passwordData, encoding: .utf8)
            return (username, password)
        }
        return (nil, nil)
    }

    static func deleteCredentials() {
        let userQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Const.usernameField
        ]
        SecItemDelete(userQuery as CFDictionary)
        
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Const.passwordField
        ]
        SecItemDelete(passwordQuery as CFDictionary)
    }
}
