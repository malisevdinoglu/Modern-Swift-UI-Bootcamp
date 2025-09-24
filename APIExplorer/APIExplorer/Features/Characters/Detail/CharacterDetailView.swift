//
//  CharacterDetailView.swift
//  APIExplorer
//
//  Created by Mehmet Ali Sevdinoğlu on 24.09.2025.
//



import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @EnvironmentObject private var favorites: FavoritesStore   // ⬅️ Favoriler

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // ✅ CachedAsyncImage ile kapak görseli
                ZStack(alignment: .bottomLeading) {
                    CachedAsyncImage(url: character.image)
                        .scaledToFill()
                        .frame(height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    // Alt kısma isim için okunabilirlik sağlayan gradient
                    LinearGradient(stops: [
                        .init(color: .clear, location: 0.5),
                        .init(color: .black.opacity(0.6), location: 1.0)
                    ], startPoint: .top, endPoint: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(height: 280)

                    Text(character.name)
                        .font(.title).bold()
                        .foregroundStyle(.white)
                        .padding()
                }

                // Temel bilgiler
                HStack(spacing: 10) {
                    StatusPill(status: character.status)
                    if let gender = character.gender {
                        Text(gender)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text(character.species)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Divider()

                // Konumlar
                VStack(alignment: .leading, spacing: 8) {
                    Label {
                        Text(character.origin?.name ?? "Unknown")
                    } icon: { Image(systemName: "globe.asia.australia.fill") }

                    Label {
                        Text(character.location?.name ?? "Unknown")
                    } icon: { Image(systemName: "mappin.and.ellipse") }
                }
                .font(.subheadline)

                // Bölüm sayısı
                if let count = character.episode?.count {
                    Label("\(count) episode", systemImage: "film.stack")
                        .font(.subheadline)
                }

                Spacer(minLength: 12)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)

        // ⭐️ Favori butonu
        .toolbar {
            Button {
                favorites.toggle(character: character)
            } label: {
                Image(systemName: favorites.isFavorite(id: character.id) ? "star.fill" : "star")
                    .foregroundStyle(favorites.isFavorite(id: character.id) ? .yellow : .primary)
            }
            .accessibilityIdentifier("fav_toggle_button")
        }
    }
}
