//
//  EventRowView.swift
//  EventFlow
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//

import SwiftUI

struct EventRowView: View {
    let event: Event

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: event.type.systemImage)
                .imageScale(.large)
                .foregroundStyle(event.type.color)

            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.headline)
                Text(event.type.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(event.date.formatted(date: .abbreviated, time: .omitted))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if event.hasReminder {
                Image(systemName: "bell.fill")
                    .imageScale(.medium)
                    .foregroundStyle(.orange)
                    .accessibilityLabel("Hatırlatıcı açık")
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    EventRowView(event: Event.samples.first!)
}
