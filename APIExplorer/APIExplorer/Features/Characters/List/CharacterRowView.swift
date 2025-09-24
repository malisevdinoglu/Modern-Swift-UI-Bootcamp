//
//  CharacterRowView.swift
//  APIExplorer
//
//  Created by Mehmet Ali Sevdinoğlu on 24.09.2025.
//

import SwiftUI

struct CharacterRowView: View {
    let character: Character
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        HStack(spacing: 12) {
            // ✅ CachedAsyncImage kullanımı
            CachedAsyncImage(url: character.image)
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(character.name).font(.headline)
                Text("\(character.species) • \(character.status)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()

            Button {
                favorites.toggle(character: character)
            } label: {
                Image(systemName: favorites.isFavorite(id: character.id) ? "star.fill" : "star")
                    .imageScale(.medium)
                    .foregroundStyle(
                        favorites.isFavorite(id: character.id) ? .yellow : .secondary
                    )
                    .accessibilityLabel(
                        favorites.isFavorite(id: character.id) ? "Favoriden çıkar" : "Favoriye ekle"
                    )
            }
            .buttonStyle(.borderless)   // row tıklamasını bozmasın
        }
        .padding(.vertical, 6)
        // ➕ Swipe action
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            if favorites.isFavorite(id: character.id) {
                Button(role: .destructive) {
                    favorites.remove(id: character.id)
                } label: {
                    Label("Favoriden çıkar", systemImage: "trash")
                }
            } else {
                Button {
                    favorites.toggle(character: character)
                } label: {
                    Label("Favoriye ekle", systemImage: "star")
                }
            }
        }
    }
}

