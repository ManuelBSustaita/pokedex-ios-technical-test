//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Manuel Sustaita on 02/07/26.
//

import SwiftUI

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            PokedexFrameView(){
                NavigationStack{
                    PokemonListView(
                        viewModel: PokemonListViewModel(service: PokemonAPIService())
                    )
                }
            }
        }
    }
}
