//
//  CharacterListViewModel.swift
//  APIExplorer
//
//  Created by Mehmet Ali Sevdinoğlu on 24.09.2025.
//

import Foundation

@MainActor
final class CharacterListViewModel: ObservableObject {
    @Published private(set) var items: [Character] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var query: String = ""

    private var currentPage = 1
    private var totalPages = Int.max
    private let service: CharacterServicing

    init(service: CharacterServicing = CharacterService()) {
        self.service = service
    }

    var canLoadMore: Bool { currentPage <= totalPages && !isLoading }

    func loadFirstPage() async {
        currentPage = 1
        totalPages = Int.max
        items = []
        await loadNextPage()
    }

    func loadNextPage() async {
        guard canLoadMore else { return }
        isLoading = true
        errorMessage = nil
        do {
            let resp = try await service.fetch(page: currentPage,
                                               name: query.isEmpty ? nil : query)
            if currentPage == 1 { items = resp.results } else { items += resp.results }
            totalPages = resp.info.pages
            currentPage += 1
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }

    func refresh() async {
        await loadFirstPage()
    }
}
