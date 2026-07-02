//
//  PokemonDetailView.swift
//  Created by Manuel Sustaita on 02/07/26.
//

import SwiftUI

struct PokemonDetailView: View {

    @StateObject var viewModel: PokemonDetailViewModel

    var body: some View {

        Group {

            if let detail = viewModel.detail {

                ScrollView {

                    VStack(spacing: 24) {

                        header(detail)

                        HStack(spacing: 16) {

                            infoCard(
                                title: "Altura",
                                value: "\(detail.heightInMeters) m",
                                icon: "ruler"
                            )

                            infoCard(
                                title: "Peso",
                                value: "\(detail.weightInKilograms) kg",
                                icon: "scalemass"
                            )

                        }

                        abilityCard(detail)

                        statsCard(detail)

                    }
                    .padding()

                }
                .background(
                    LinearGradient(
                        colors: [
                            Color.red.opacity(0.08),
                            .white
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            } else if viewModel.isLoading {

                ProgressView()

            } else if let error = viewModel.errorMessage {

                errorView(error)

            }

        }
        .task {
            await viewModel.load()
        }
    }

    // MARK: Header

    private func header(_ detail: PokemonDetail) -> some View {

        VStack(spacing: 18) {

            ZStack {

                Circle()
                    .fill(.white)
                    .frame(width: 180, height: 180)

                Circle()
                    .stroke(.gray.opacity(0.15), lineWidth: 5)
                    .frame(width: 180, height: 180)

                RemoteImage(url: detail.sprites.imageURL)
                    .frame(width: 140, height: 140)

            }
            .shadow(radius: 8)

            VStack(spacing: 6) {

                Text(detail.displayName)
                    .font(.system(size: 32, weight: .heavy))

                Text("#\(String(format: "%03d", detail.id))")
                    .foregroundStyle(.secondary)

            }

            HStack {

                ForEach(detail.typeNames, id: \.self) { type in

                    Text(type.capitalized)
                        .font(.caption.bold())
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .foregroundStyle(.white)
                        .background(typeColor(type))
                        .clipShape(Capsule())

                }

            }

        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 8)

    }

    // MARK: Info Card

    private func infoCard(
        title: String,
        value: String,
        icon: String
    ) -> some View {

        VStack(spacing: 12) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.red)

            Text(value)
                .font(.title2.bold())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 8)
    }

    // MARK: Abilities

    private func abilityCard(_ detail: PokemonDetail) -> some View {

        VStack(alignment: .leading, spacing: 14) {

            Label("Habilidades", systemImage: "sparkles")
                .font(.headline)

            ForEach(detail.abilities, id: \.ability.name) { ability in
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)

                    Text(ability.ability.name.capitalized)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 8)

    }

    // MARK: Stats

    private func statsCard(_ detail: PokemonDetail) -> some View {

        VStack(alignment: .leading, spacing: 18) {

            Label("Estadísticas", systemImage: "chart.bar.fill")
                .font(.headline)

            ForEach(detail.stats, id: \.stat.name) { stat in
                statRow(
                    name: stat.stat.name,
                    value: stat.baseStat
                )
            }

        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 8)

    }

    private func statRow(
        name: String,
        value: Int
    ) -> some View {

        VStack(alignment: .leading, spacing: 6) {

            HStack {

                Text(name.capitalized)

                Spacer()

                Text("\(value)")
                    .bold()

            }

            GeometryReader { geo in

                ZStack(alignment: .leading) {

                    Capsule()
                        .fill(.gray.opacity(0.2))

                    Capsule()
                        .fill(typeColor(viewModel.detail?.typeNames.first ?? ""))
                        .frame(
                            width: geo.size.width * CGFloat(value) / 255
                        )

                }

            }
            .frame(height: 10)

        }

    }

    // MARK: Error

    private func errorView(_ message: String) -> some View {

        VStack(spacing: 16) {

            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))

            Text(message)

            Button("Reintentar") {

                Task {
                    await viewModel.load()
                }

            }
            .buttonStyle(.borderedProminent)

        }

    }

    // MARK: Type Color

    private func typeColor(_ type: String) -> Color {

        switch type.lowercased() {

        case "fire":
            return .red

        case "water":
            return .blue

        case "grass":
            return .green

        case "electric":
            return .yellow

        case "ice":
            return .cyan

        case "rock":
            return .brown

        case "ground":
            return .orange

        case "psychic":
            return .pink

        case "ghost":
            return .indigo

        case "poison":
            return .purple

        default:
            return .gray

        }

    }

}
