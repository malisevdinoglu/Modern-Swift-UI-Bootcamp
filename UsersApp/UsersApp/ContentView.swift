//
//  ContentView.swift
//  UsersApp
//
//  Created by Mehmet Ali Sevdinoğlu on 18.09.2025.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var vm = UsersViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Yükleniyor…")
                } else if let message = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text(message)
                            .foregroundStyle(.red)
                        Button("Tekrar Dene") {
                            Task { await vm.load() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if vm.filteredUsers.isEmpty {
                    ContentUnavailableView(
                        "Sonuç bulunamadı",
                        systemImage: "magnifyingglass",
                        description: Text("Farklı bir anahtar kelime deneyin.")
                    )
                } else {
                    List(vm.filteredUsers) { user in
                        NavigationLink {
                               UserDetailView(user: user)
                           } label: {
                               UserRow(user: user)
                           }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Kullanıcılar")
        }
        .task {                    // Ekran açılınca verileri yükle
            await vm.load()
        }
        .refreshable {             // Aşağı çekerek yenile
            await vm.load()
        }
        .searchable(               // Arama/filtre
            text: $vm.searchText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: "İsim, kullanıcı adı, email"
        )
        .toolbar {
            if !vm.searchText.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Temizle") { vm.searchText = "" }
                }
            }
        }
    }
}

struct UserRow: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(user.name)
                .font(.headline)
            Text("@\(user.username)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(user.email)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
}
