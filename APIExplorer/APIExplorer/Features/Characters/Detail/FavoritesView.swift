//
//  FavoritesView.swift
//  APIExplorer
//
//  Created by Mehmet Ali Sevdinoğlu on 24.09.2025.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        List {
            if favorites.items.isEmpty {
                ContentUnavailableView {
                    Label("Favoriniz yok", systemImage: "star")
                } description: {
                    Text("Listeden yıldızlayarak favori ekleyin.")
                }
            } else {
                ForEach(favorites.items) { fav in
                    HStack(spacing: 12) {
                        AsyncImage(url: fav.image) { phase in
                            switch phase {
                            case .empty: ProgressView().frame(width: 56, height: 56)
                            case .success(let img):
                                img.resizable().scaledToFill()
                                    .frame(width: 56, height: 56)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            case .failure: Image(systemName: "photo").frame(width: 56, height: 56)
                            @unknown default: EmptyView()
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(fav.name).font(.headline)
                            Text("#\(fav.id)").font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button(role: .destructive) {
                            favorites.remove(id: fav.id)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("Favoriler")
    }
}
