//
//  NoteRow.swift
//  Not Defteri
//
//  Created by Mehmet Ali Sevdinoğlu on 12.09.2025.
//
import SwiftUI

struct NoteRow: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(note.title)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text(note.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(note.content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}
