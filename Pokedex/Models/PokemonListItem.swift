//
//  PokemonListItem.swift
//  Created by Manuel Sustaita on 02/07/26.
//

import Foundation

// TODO: struct PokemonListResponse: Decodable
struct PokemonListResponse:Codable{
    let count:Int?
    let next:String?
    let results:[PokemonListItem]
}

struct PokemonListItem: Codable, Identifiable, Hashable {
    let name: String
    let url: String

    var id: Int {
        let trimmed = url.hasSuffix("/") ? String(url.dropLast()) : url
        guard let idString = trimmed.split(separator: "/").last,
              let id = Int(idString) else {
            return 0
        }
        return id
    }

    /// URL del artwork oficial, construida a partir del id.
    var imageURL: URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }

    var displayName: String {
        name.capitalized
    }
}
