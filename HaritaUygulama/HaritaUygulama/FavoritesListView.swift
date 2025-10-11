//
//  FavoritesListView.swift
//  HaritaUygulama
//
//  Created by Mehmet Ali Sevdinoğlu on 11.10.2025.
//

import SwiftUI
import SwiftData

struct FavoritesListView: View {
    
    @Query(sort: \FavoriteLocation.timestamp, order: .reverse) private var favoriteLocations: [FavoriteLocation]
   
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        
        NavigationStack {
         
            List {
                
                ForEach(favoriteLocations) { location in
                    VStack(alignment: .leading) {
                        Text(location.name)
                            .font(.headline)
                    
                        Text("Eklendi: \(location.timestamp, format: .dateTime.day().month().year())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
               
                .onDelete(perform: deleteFavoriteLocation)
            }
            .navigationTitle("Favori Konumlar")
            .overlay {
               
                if favoriteLocations.isEmpty {
                    ContentUnavailableView(
                        "Henüz Favori Konum Eklenmedi",
                        systemImage: "star.slash",
                        description: Text("Harita ekranına gidip bir konuma basılı tutarak favorilerinize ekleyebilirsiniz.")
                    )
                }
            }
        }
    }
    

    private func deleteFavoriteLocation(at offsets: IndexSet) {
        for index in offsets {
            let locationToDelete = favoriteLocations[index]
            modelContext.delete(locationToDelete)
        }
    }
}

#Preview {
    FavoritesListView()
      
        .modelContainer(for: FavoriteLocation.self, inMemory: true)
}
