//
//  PokemonDetailViewModel.swift
//  Created by Manuel Sustaita on 02/07/26.
//
import Foundation

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published private(set) var detail: PokemonDetail?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let service: PokemonServiceProtocol
    private let pokemonID: Int

    init(service: PokemonServiceProtocol, pokemonID: Int) {
        self.service = service
        self.pokemonID = pokemonID
    }

    func load() async {
        guard detail == nil else { return }

        isLoading = true
        errorMessage = nil

        do {
            detail = try await service.fetchPokemonDetail(id: pokemonID)
        } catch {
            errorMessage = "No se pudo cargar la información de este Pokémon."
        }

        isLoading = false
    }
}
