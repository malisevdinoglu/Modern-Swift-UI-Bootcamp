//
//  TaskRowView.swift
//  TaskManagerMVVM
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//

import SwiftUI

/// Tek satır görünümü: Tamamlama durumunu değiştiren buton.
struct TaskRowView: View {
    let task: TaskItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                    .accessibilityLabel(task.isCompleted ? "Tamamlandı" : "Tamamlanmadı")
            }
            .buttonStyle(.plain)
            
            Text(task.title)
                .strikethrough(task.isCompleted, color: .secondary)
                .foregroundStyle(task.isCompleted ? .secondary : .primary)
                .lineLimit(2)
            
            Spacer()
        }
        .contentShape(Rectangle()) // Satırın her yerine tıklanabilirlik
        .onTapGesture(perform: onToggle)
    }
}
