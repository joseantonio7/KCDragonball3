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
    
    static func loadNoData() throws -> Data {
        return Data()
    }
    
    static func login() throws -> Data {
        return "eyJraWQiOiJwcml2YXRlIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJpZGVudGlmeSI6IjdBQjhBQzRELUFEOEYtNEFDRS1BQTQ1LTIxRTg0QUU4QkJFNyIsImVtYWlsIjoiYmVqbEBrZWVwY29kaW5nLmVzIiwiZXhwaXJhdGlvbiI6NjQwOTIyMTEyMDB9.Dxxy91hTVz3RTF7w1YVTJ7O9g71odRcqgD00gspm30s".data(using: .utf8)!
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
