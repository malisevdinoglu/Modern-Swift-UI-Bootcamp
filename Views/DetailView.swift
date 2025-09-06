//
//  DetailView.swift
//  MasterListApp
//
//  Created by Mehmet Ali Sevdinoğlu on 6.09.2025.
//

import SwiftUI

struct DetailView: View {
    let item: TodoItem
    private let symbolName: String = SFSymbols.randomName() // her girişte rastgele

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: symbolName)
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)
                .padding()

            Text(item.title)
                .font(.title)
                .bold()

            Text(item.detail)
                .font(.body)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Detay")
        .navigationBarTitleDisplayMode(.inline)
    }
}

enum SFSymbols {
    static let pool: [String] = [
        "star.fill", "bolt.fill", "flame.fill", "leaf.fill", "paperplane.fill",
        "heart.fill", "bookmark.fill", "pencil", "camera.fill", "cloud.fill",
        "moon.fill", "sun.max.fill", "hare.fill", "tortoise.fill",
        "globe.europe.africa.fill", "bell.fill", "list.bullet", "clock.fill",
        "folder.fill", "wand.and.stars"
    ]

    static func randomName() -> String { pool.randomElement() ?? "star" }
}
