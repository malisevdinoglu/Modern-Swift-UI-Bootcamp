//
//  NetworkService.swift
//  APIExplorer
//
//  Created by Mehmet Ali Sevdinoğlu on 24.09.2025.
//

import Foundation

enum APIError: LocalizedError {
    case badURL
    case invalidResponse
    case http(Int)
    case decode(Error)

    var errorDescription: String? {
        switch self {
        case .badURL: return "Geçersiz URL"
        case .invalidResponse: return "Geçersiz yanıt"
        case .http(let code): return "Sunucu hatası: \(code)"
        case .decode(let err): return "Çözümleme hatası: \(err.localizedDescription)"
        }
    }
}

protocol NetworkServicing {
    func get<T: Decodable>(_ path: String, queryItems: [URLQueryItem]) async throws -> T
}

final class NetworkService: NetworkServicing {
    private let baseURL = URL(string: "https://rickandmortyapi.com/api")!
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func get<T: Decodable>(_ path: String, queryItems: [URLQueryItem] = []) async throws -> T {
        var url = baseURL.appendingPathComponent(path)
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        if !queryItems.isEmpty { comps.queryItems = queryItems }
        guard let finalURL = comps.url else { throw APIError.badURL }

        let (data, resp) = try await session.data(from: finalURL)
        guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard 200..<300 ~= http.statusCode else { throw APIError.http(http.statusCode) }
        do { return try decoder.decode(T.self, from: data) }
        catch { throw APIError.decode(error) }
    }
}

// Özelleşmiş servis
protocol CharacterServicing {
    func fetch(page: Int?, name: String?) async throws -> CharactersResponse
}

final class CharacterService: CharacterServicing {
    private let network: NetworkServicing
    init(network: NetworkServicing = NetworkService()) { self.network = network }

    func fetch(page: Int? = nil, name: String? = nil) async throws -> CharactersResponse {
        var items: [URLQueryItem] = []
        if let page { items.append(.init(name: "page", value: String(page))) }
        if let name, !name.isEmpty { items.append(.init(name: "name", value: name)) }
        return try await network.get("character", queryItems: items)
    }
}
