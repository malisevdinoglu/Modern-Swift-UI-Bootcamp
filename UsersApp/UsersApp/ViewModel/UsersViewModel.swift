//
//  UsersViewModel.swift
//  UsersApp
//
//  Created by Mehmet Ali Sevdinoğlu on 18.09.2025.
//
import Foundation

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // 🔎 Arama metni
    @Published var searchText: String = ""

    private let api = APIClient()

    // Filtrelenmiş liste (isim / kullanıcı adı / email)
    var filteredUsers: [User] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return users }
        return users.filter { user in
            user.name.localizedCaseInsensitiveContains(q) ||
            user.username.localizedCaseInsensitiveContains(q) ||
            user.email.localizedCaseInsensitiveContains(q)
        }
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await api.fetchUsers()
            users = result
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Bir hata oluştu."
        }
        isLoading = false
    }
}
