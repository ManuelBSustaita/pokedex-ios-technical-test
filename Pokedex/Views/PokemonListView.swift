//
//  PokemonListView.swift
//  Created by Manuel Sustaita on 02/07/26.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel: PokemonListViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Cargando Pokémon...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .loaded(let pokemons):
                list(pokemons)
            case .empty:
                emptyView
            case .error(let message):
                errorView(message)
            }
        }
        .navigationTitle("Pokédex")
        .task {
            await viewModel.loadInitial()
        }
    }

    private func list(_ pokemons: [PokemonListItem]) -> some View {
        List(pokemons) { item in
            NavigationLink(value: item) {
                PokemonRowView(item: item)
            }
            .task {
                await viewModel.loadMoreIfNeeded(currentItem: item)
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: PokemonListItem.self) { item in
            PokemonDetailView(viewModel: viewModel.makeDetailViewModel(for: item))
        }
        .overlay(alignment: .bottom) {
            if viewModel.isLoadingMore {
                ProgressView()
                    .padding(.bottom, 12)
            }
        }
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "questionmark.circle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("No se encontraron Pokémon.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Reintentar") {
                Task { await viewModel.loadInitial() }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
