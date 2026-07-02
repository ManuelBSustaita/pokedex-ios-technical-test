//
//  RemoteImage.swift
//  Pokedex
//
//  Created by Manuel Sustaita on 02/07/26.
//

import Foundation
import SwiftUI

struct RemoteImage: View {

    let url: URL?

    var body: some View {

        AsyncImage(url: url) { phase in

            switch phase {

            case .empty:
                ProgressView()

            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)

            case .failure:
                Image(systemName: "photo")

            @unknown default:
                EmptyView()
            }
        }
    }
}
