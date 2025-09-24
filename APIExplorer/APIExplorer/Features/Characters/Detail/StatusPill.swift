//
//  StatusPill.swift
//  APIExplorer
//
//  Created by Mehmet Ali Sevdinoğlu on 24.09.2025.
//

import SwiftUI

struct StatusPill: View {
    let status: String

    private var color: Color {
        switch status.lowercased() {
        case "alive": return .green
        case "dead":  return .red
        default:      return .gray
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            Circle().frame(width: 8, height: 8).foregroundStyle(color)
            Text(status)
                .font(.caption).bold()
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
    }
}
