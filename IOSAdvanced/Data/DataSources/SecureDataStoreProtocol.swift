//
//  SecureDataStoreProtocol.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 26-10-24.
//

import KeychainSwift

protocol SecureDataStoreProtocol {
    
    func set(token: String)
    func getToken() -> String?
    func deleteToken()
}

class SecureDataStore: SecureDataStoreProtocol {
    
    private let kToken = "kToken"
    private let keychain  = KeychainSwift()
    
    static let shared: SecureDataStore = .init()
    
    func set(token: String) {
        keychain.set(token, forKey: kToken)
    }
    
    func getToken() -> String? {
        keychain.get(kToken)
    }
    
    func deleteToken() {
        keychain.delete(kToken)
    }
}
