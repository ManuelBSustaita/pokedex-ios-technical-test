//
//  PokemonCache.swift
//  Pokedex
//
//  Created by Manuel Sustaita on 02/07/26.
//

import Foundation

protocol PokemonCacheProtocol {
    func saveList(_ response: PokemonListResponse, page: Int)
    func loadList(page: Int) -> PokemonListResponse?

    func saveDetail(_ detail: PokemonDetail)
    func loadDetail(id: Int) -> PokemonDetail?
}

final class PokemonCache: PokemonCacheProtocol {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    init() {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cacheDirectory = caches.appendingPathComponent("PokedexCache", isDirectory: true)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    func saveList(_ response: PokemonListResponse, page: Int) {
        write(response, to: "list_page_\(page).json")
    }

    func loadList(page: Int) -> PokemonListResponse? {
        read(PokemonListResponse.self, from: "list_page_\(page).json")
    }

    func saveDetail(_ detail: PokemonDetail) {
        write(detail, to: "detail_\(detail.id).json")
    }

    func loadDetail(id: Int) -> PokemonDetail? {
        read(PokemonDetail.self, from: "detail_\(id).json")
    }

    private func write<T: Encodable>(_ value: T, to filename: String) {
        let url = cacheDirectory.appendingPathComponent(filename)
        guard let data = try? JSONEncoder().encode(value) else { return }
        try? data.write(to: url, options: .atomic)
    }

    private func read<T: Decodable>(_ type: T.Type, from filename: String) -> T? {
        let url = cacheDirectory.appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
