//
//  SecureDataStorageMock.swift
//  IOSAdvancedTests
//
//  Created by José Antonio Aravena on 27-10-24.
//

import Foundation
@testable import IOSAdvanced

class SecureDataStorageMock: SecureDataStoreProtocol {
    
    private let kToken = "kToken"
    private var userDefaults = UserDefaults.standard
    
    func set(token: String) {
        userDefaults.set(token, forKey: kToken)
    }
    
    func getToken() -> String? {
        userDefaults.string(forKey: kToken)
    }
    
    func deleteToken() {
        userDefaults.removeObject(forKey: kToken)
    }
}
