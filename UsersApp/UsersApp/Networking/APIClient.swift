//
//  APIClient.swift
//  UsersApp
//
//  Created by Mehmet Ali Sevdinoğlu on 18.09.2025.
//
import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:   return "Geçersiz URL."
        case .requestFailed:return "İstek başarısız oldu."
        case .decodingFailed:return "Veri çözümlenemedi."
        }
    }
}

struct APIClient {
    static let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!

    func fetchUsers() async throws -> [User] {
        let url = Self.baseURL.appendingPathComponent("users")
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw APIError.requestFailed
        }

        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}
