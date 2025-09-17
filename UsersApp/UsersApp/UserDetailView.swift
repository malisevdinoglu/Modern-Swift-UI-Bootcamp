//
//  UserDetailView.swift
//  UsersApp
//
//  Created by Mehmet Ali Sevdinoğlu on 18.09.2025.
//

import SwiftUI

struct UserDetailView: View {
    let user: User

    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    AsyncImage(url: user.avatarURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 72, height: 72)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 72, height: 72)
                                .clipShape(Circle())
                        case .failure:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 72, height: 72)
                                .foregroundStyle(.secondary)
                        @unknown default:
                            EmptyView()
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name).font(.title3).bold()
                        Text("@\(user.username)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

            Section("İletişim") {
                LabeledContent("Email") {
                    Text(user.email).textSelection(.enabled)
                }
                // İstersen burada telefon/website alanlarını da
                // modele ekleyip gösterebilirsin.
            }
        }
        .navigationTitle("Detay")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UserDetailView(user: .init(id: 1, name: "Leanne Graham", username: "Bret", email: "leanne@example.com"))
}
