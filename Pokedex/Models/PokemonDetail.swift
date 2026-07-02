//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Manuel Sustaita on 02/07/26.
//

import Foundation

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int   // decímetros
    let weight: Int   // hectogramos
    let types: [PokemonTypeEntry]
    let abilities: [PokemonAbilityEntry]
    let stats: [PokemonStatEntry]
    let sprites: PokemonSprites

    var displayName: String {
        name.capitalized
    }

    var heightInMeters: Double {
        Double(height) / 10.0
    }

    var weightInKilograms: Double {
        Double(weight) / 10.0
    }

    var typeNames: [String] {
        types.map { $0.type.name }
    }
}

// MARK: - Types

struct PokemonTypeEntry: Codable {
    let type: PokemonTypeName
}

struct PokemonTypeName: Codable {
    let name: String
}


struct PokemonAbilityEntry: Codable {
    let ability: PokemonAbilityName
    let isHidden: Bool

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
    }
}

struct PokemonAbilityName: Codable {
    let name: String
}

// MARK: - Stats

struct PokemonStatEntry: Codable {
    let baseStat: Int
    let stat: PokemonStatName

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct PokemonStatName: Codable {
    let name: String
}

// MARK: - Images

struct PokemonSprites: Codable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }

    var imageURL: URL? {
        guard let frontDefault else { return nil }
        return URL(string: frontDefault)
    }
}
