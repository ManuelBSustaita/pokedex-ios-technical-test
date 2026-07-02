//
//  PokemonListViewModel.swift
//  Created by Manuel Sustaita on 02/07/26.
//

import Foundation
enum ListState {
    case loading
    case loaded([PokemonListItem])
    case empty
    case error(String)
}

@MainActor
final class PokemonListViewModel: ObservableObject {
    @Published private(set) var state: ListState = .loading
    @Published private(set) var isLoadingMore = false
    private let service: PokemonServiceProtocol
    private var currentOffset = 0
    private let pageSize = 20
    private var canLoadMore = true
    private var loadedPokemons: [PokemonListItem] = []

    init(service: PokemonServiceProtocol) {
        self.service = service
    }

    func loadInitial() async {
        guard loadedPokemons.isEmpty else { return }
        await loadNextPage()
    }

    func loadMoreIfNeeded(currentItem item: PokemonListItem) async {
        guard canLoadMore, !isLoadingMore else { return }
        let thresholdIndex = loadedPokemons.index(loadedPokemons.endIndex, offsetBy: -5, limitedBy: loadedPokemons.startIndex) ?? loadedPokemons.startIndex
        if let itemIndex = loadedPokemons.firstIndex(where: { $0.id == item.id }),
           itemIndex >= thresholdIndex {
            await loadNextPage()
        }
    }

    func makeDetailViewModel(for item: PokemonListItem) -> PokemonDetailViewModel {
        PokemonDetailViewModel(service: service, pokemonID: item.id)
    }

    private func loadNextPage() async {
        isLoadingMore = true
        if loadedPokemons.isEmpty { state = .loading }

        do {
            let response = try await service.fetchPokemonList(limit: pageSize, offset: currentOffset)
            loadedPokemons.append(contentsOf: response.results)
            currentOffset += pageSize
            canLoadMore = response.next != nil

            state = loadedPokemons.isEmpty ? .empty : .loaded(loadedPokemons)
        } catch {
            state = .error("No se pudo cargar el listado de Pokémon. Intenta de nuevo.")
        }

        isLoadingMore = false
    }
}
