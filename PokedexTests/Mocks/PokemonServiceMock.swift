//
//  PokemonServiceMock.swift
//  PokedexTests/Mocks
//  Created by Manuel Sustaita on 02/07/26.
//

import Foundation
@testable import Pokedex

final class PokemonServiceMock: PokemonServiceProtocol {
    // Configura esto desde cada test antes de llamar al ViewModel
    var listResultToReturn: PokemonListResponse?
    var detailResultToReturn: PokemonDetail?
    var errorToThrow: Error?

    // Para verificar que se llamó con los parámetros esperados
    private(set) var fetchListCallCount = 0
    private(set) var fetchDetailCallCount = 0
    private(set) var lastRequestedID: Int?

    func fetchPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse {
        fetchListCallCount += 1
        if let errorToThrow {
            throw errorToThrow
        }
        guard let listResultToReturn else {
            fatalError("listResultToReturn no fue configurado en el test")
        }
        return listResultToReturn
    }

    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        fetchDetailCallCount += 1
        lastRequestedID = id
        if let errorToThrow {
            throw errorToThrow
        }
        guard let detailResultToReturn else {
            fatalError("detailResultToReturn no fue configurado en el test")
        }
        return detailResultToReturn
    }
}
