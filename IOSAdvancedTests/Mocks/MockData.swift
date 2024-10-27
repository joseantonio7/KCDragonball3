//
//  File.swift
//  IOSAdvancedTests
//
//  Created by José Antonio Aravena on 27-10-24.
//

import Foundation
@testable import IOSAdvanced

class MockData {
    
    static func loadHeroesData() throws -> Data {
        let bundle = Bundle(for: MockData.self)
        guard let url = bundle.url(forResource: "Heroes", withExtension: "json"),
              let data = try? Data.init(contentsOf: url)  else {
            throw NSError(domain: "io.keepcoding.GokuandFriends", code: -1)
        }
        return data
    }

    static func mockHeroes() throws -> [ApiHero] {
        do {
            let data = try self.loadHeroesData()
            let heroes = try JSONDecoder().decode([ApiHero].self, from: data)
            return heroes
        } catch {
            throw error
        }
    }
}
