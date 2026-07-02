//
//  PokemonRowView.swift
//  Created by Manuel Sustaita on 02/07/26.
//

import SwiftUI

struct PokemonRowView: View {
    let item: PokemonListItem

    var body: some View {
        HStack(spacing: 12) {
            RemoteImage(url: item.imageURL)
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.displayName)
                    .font(.headline)
                Text("#\(String(format: "%03d", item.id))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

