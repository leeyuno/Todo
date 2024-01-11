//
//  Environment.swift
//  Todos
//
//  Created by Hanna Shin's iMac on 12/27/23.
//

import Foundation
import Dependencies

struct SomeStruct: Codable {
    var name: String?
}

enum APIError: Error {
    case invalidURL
}

struct AppEnvironment {
    var fetch: (Int) async throws -> SomeStruct
}

extension AppEnvironment: DependencyKey {
    static let liveValue = Self { todos in
        guard let url = URL(string: "") else {
            throw APIError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: URL(string: "")!)
        return try JSONDecoder().decode(SomeStruct.self, from: data)
    }
}

extension DependencyValues {
    var numberFact: AppEnvironment {
        get { self[AppEnvironment.self] }
        set { self[AppEnvironment.self] = newValue }
    }
}
