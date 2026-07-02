//  Created by Manuel Sustaita on 02/07/26.

import Foundation


protocol PokemonServiceProtocol {
    func fetchPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail
}

struct PokemonAPIService: PokemonServiceProtocol {
    private let baseURL = "https://pokeapi.co/api/v2"
    private let cache: PokemonCacheProtocol

    init(cache: PokemonCacheProtocol = PokemonCache()) {
        self.cache = cache
    }

    func fetchPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse {
        guard let url = listURL(limit: limit, offset: offset) else {
            throw APIError.invalidURL
        }

        let page = offset / limit

        do {
            let response: PokemonListResponse = try await fetch(url)
            cache.saveList(response, page: page)
            return response
        } catch {
            if let cached = cache.loadList(page: page) {
                return cached
            }
            throw error
        }
    }

    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        guard let url = detailURL(id: id) else {
            throw APIError.invalidURL
        }

        do {
            let detail: PokemonDetail = try await fetch(url)
            cache.saveDetail(detail)
            return detail
        } catch {
            if let cached = cache.loadDetail(id: id) {
                return cached
            }
            throw error
        }
    }

    private func listURL(limit: Int, offset: Int) -> URL? {
        URL(string: "\(baseURL)/pokemon?limit=\(limit)&offset=\(offset)")
    }

    private func detailURL(id: Int) -> URL? {
        URL(string: "\(baseURL)/pokemon/\(id)")
    }

    private func fetch<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.requestFailed
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}
