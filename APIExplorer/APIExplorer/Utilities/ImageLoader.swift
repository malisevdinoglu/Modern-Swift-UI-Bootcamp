//
//  ImageLoader.swift
//  APIExplorer
//
//  Created by Mehmet Ali Sevdinoğlu on 25.09.2025.
//
import SwiftUI

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private static let cache = NSCache<NSURL, UIImage>()

    func load(from url: URL) {
        if let cached = Self.cache.object(forKey: url as NSURL) {
            self.image = cached
            return
        }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let ui = UIImage(data: data) {
                    Self.cache.setObject(ui, forKey: url as NSURL)
                    self.image = ui
                }
            } catch {
                print("Image load error:", error)
            }
        }
    }
}

struct CachedAsyncImage: View {
    @StateObject private var loader = ImageLoader()
    let url: URL

    var body: some View {
        Group {
            if let img = loader.image {
                Image(uiImage: img).resizable()
            } else {
                ProgressView()
            }
        }
        .onAppear { loader.load(from: url) }
    }
}

