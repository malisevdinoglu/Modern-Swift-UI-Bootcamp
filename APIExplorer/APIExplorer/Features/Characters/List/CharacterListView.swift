//
//  CharacterListView.swift
//  APIExplorer
//
//  Created by Mehmet Ali Sevdinoğlu on 24.09.2025.
//
import SwiftUI

struct CharacterListView: View {
    @StateObject private var vm = CharacterListViewModel()
    @State private var searchText = ""   // Yerel arama metni
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        List {
            ForEach(vm.items) { item in
                NavigationLink(value: item) {
                    CharacterRowView(character: item)
                }
                .onAppear {
                    if item.id == vm.items.last?.id {
                        Task { await vm.loadNextPage() }
                    }
                }
            }

            if vm.isLoading {
                HStack { Spacer(); ProgressView(); Spacer() }
            }
        }
        .navigationTitle("Characters")

        // 🔎 Arama alanı (yerel state'e bağlı)
        .searchable(text: $searchText, prompt: "İsme göre ara")
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)

        // ⌨️ Enter'a basıldığında da ara
        .onSubmit(of: .search) {
            Task {
                vm.query = searchText
                await vm.loadFirstPage()
            }
        }

        // 🕒 Debounce: searchText değiştikçe 350ms bekle, ara
        .task(id: searchText) {
            try? await Task.sleep(nanoseconds: 350_000_000)   // 350ms
            guard !Task.isCancelled else { return }
            vm.query = searchText
            await vm.loadFirstPage()
        }

        // ⤵️ Pull-to-refresh
        .refreshable { await vm.refresh() }

        // 🧭 Detay
        .navigationDestination(for: Character.self) { item in
            CharacterDetailView(character: item)
        }

        // ⭐️ Favoriler kısayolu
        .toolbar {
            NavigationLink(destination: FavoritesView()) {
                Label("\(favorites.items.count)", systemImage: "star")
            }
            .accessibilityIdentifier("open_favorites_button")
        }

        // 📥 İlk açılışta veriyi çek
        .task {
            await vm.loadFirstPage()
        }

        // 🧯 Boş/Hata durumu (iOS 16 uyumlu sade sürüm)
        .overlay {
            if let err = vm.errorMessage, vm.items.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "wifi.exclamationmark").font(.largeTitle)
                    Text("Bir şeyler ters gitti").font(.headline)
                    Text(err).font(.footnote).foregroundStyle(.secondary)
                    Button("Tekrar dene") { Task { await vm.loadFirstPage() } }
                        .buttonStyle(.borderedProminent)
                }.padding()
            } else if !vm.isLoading && vm.items.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").font(.largeTitle)
                    Text("Sonuç yok")
                    Text(searchText.isEmpty
                         ? "Bir isim yazmayı deneyin."
                         : "“\(searchText)” için sonuç bulunamadı.")
                    .font(.footnote).foregroundStyle(.secondary)
                }.padding()
            }
        }
    }
}
