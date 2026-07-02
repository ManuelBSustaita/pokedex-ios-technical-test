//
//  PokemonDetailViewModel.swift
//  PokedexTests
//
//  Created by Manuel Sustaita on 02/07/26.
//

import Foundation
import XCTest
@testable import Pokedex
@MainActor
final class PokemonDetailViewModelTests: XCTestCase {

    func test_load_success_setsDetail() async {
        let mock = PokemonServiceMock()
        mock.detailResultToReturn = PokemonDetail(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            types: [],
            abilities: [],
            stats: [],
            sprites: PokemonSprites(frontDefault: nil)
        )
        let viewModel = PokemonDetailViewModel(service: mock, pokemonID: 1)

        await viewModel.load()

        XCTAssertEqual(viewModel.detail?.name, "bulbasaur")
        XCTAssertEqual(mock.lastRequestedID, 1)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_load_failure_setsErrorMessage() async {
        let mock = PokemonServiceMock()
        mock.errorToThrow = MockError.sample
        let viewModel = PokemonDetailViewModel(service: mock, pokemonID: 1)

        await viewModel.load()

        XCTAssertNil(viewModel.detail)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
