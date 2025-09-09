//
//  EventType.swift
//  EventFlow
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//

import SwiftUI

enum EventType: String, CaseIterable, Identifiable, Codable {
    case dogumGunu = "Doğum Günü"
    case toplanti = "Toplantı"
    case tatil = "Tatil"
    case spor = "Spor"
    case diger = "Diğer"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .dogumGunu: return "gift.fill"
        case .toplanti:  return "person.2.fill"
        case .tatil:     return "sun.max.fill"
        case .spor:      return "sportscourt.fill"
        case .diger:     return "calendar"
        }
    }

    var color: Color {
        switch self {
        case .dogumGunu: return .pink
        case .toplanti:  return .blue
        case .tatil:     return .yellow
        case .spor:      return .green
        case .diger:     return .gray
        }
    }
}
