//
//  PokemonListViewModelTests.swift
//  PokedexTests
//  Created by Manuel Sustaita on 02/07/26.
//

import XCTest
@testable import Pokedex
@MainActor
final class PokemonListViewModelTests: XCTestCase {

    func test_loadInitial_success_updatesStateToLoaded() async {
        // Arrange
        let mock = PokemonServiceMock()
        mock.listResultToReturn = PokemonListResponse(
            count: 2,
            next: nil,
            results: [
                PokemonListItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                PokemonListItem(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/")
            ]
        )
        let viewModel = PokemonListViewModel(service: mock)

        // Act
        await viewModel.loadInitial()

        // Assert
        if case .loaded(let pokemons) = viewModel.state {
            XCTAssertEqual(pokemons.count, 2)
            XCTAssertEqual(pokemons.first?.name, "bulbasaur")
        } else {
            XCTFail("Se esperaba estado .loaded, se obtuvo \(viewModel.state)")
        }
        XCTAssertEqual(mock.fetchListCallCount, 1)
    }

    func test_loadInitial_failure_updatesStateToError() async {
        // Arrange
        let mock = PokemonServiceMock()
        mock.errorToThrow = MockError.sample
        let viewModel = PokemonListViewModel(service: mock)

        // Act
        await viewModel.loadInitial()

        // Assert
        if case .error = viewModel.state {
            // OK
        } else {
            XCTFail("Se esperaba estado .error, se obtuvo \(viewModel.state)")
        }
    }

    func test_loadInitial_emptyResults_updatesStateToEmpty() async {
        let mock = PokemonServiceMock()
        mock.listResultToReturn = PokemonListResponse(count: 0, next: nil, results: [])
        let viewModel = PokemonListViewModel(service: mock)

        await viewModel.loadInitial()

        if case .empty = viewModel.state {
            // OK
        } else {
            XCTFail("Se esperaba estado .empty, se obtuvo \(viewModel.state)")
        }
    }

    func test_loadInitial_calledTwice_onlyFetchesOnce() async {
        let mock = PokemonServiceMock()
        mock.listResultToReturn = PokemonListResponse(
            count: 1, next: nil,
            results: [PokemonListItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")]
        )
        let viewModel = PokemonListViewModel(service: mock)

        await viewModel.loadInitial()
        await viewModel.loadInitial()

        XCTAssertEqual(mock.fetchListCallCount, 1)
    }
}
