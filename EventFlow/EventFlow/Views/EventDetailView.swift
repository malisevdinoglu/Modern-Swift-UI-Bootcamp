
import SwiftUI

struct EventDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: EventStore

    let eventID: UUID

    var body: some View {
        Group {
            if let eventBinding = binding(for: eventID) {
                let event = eventBinding.wrappedValue

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 10) {
                            Image(systemName: event.type.systemImage)
                                .imageScale(.large)
                                .foregroundStyle(event.type.color)
                            Text(event.title)
                                .font(.title2).bold()
                            Spacer()
                        }

                        labeledRow("Tarih", event.date.formatted(date: .long, time: .omitted))
                        labeledRow("Tür", event.type.rawValue)

                        Toggle("Hatırlatıcı", isOn: eventBinding.hasReminder)
                            .padding(.top, 8)
                    }
                    .padding()
                }
                .navigationTitle("Detay")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .destructive) {
                            store.delete(id: eventID)
                            dismiss()
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
                    }
                }
            } else {
                ContentUnavailableView("Etkinlik bulunamadı", systemImage: "exclamationmark.triangle")
            }
        }
    }

    private func binding(for id: UUID) -> Binding<Event>? {
        guard let index = store.events.firstIndex(where: { $0.id == id }) else { return nil }
        return $store.events[index]
    }

    @ViewBuilder private func labeledRow(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.subheadline).foregroundStyle(.secondary)
            Text(value).font(.headline)
        }
    }
}

#Preview {
    NavigationStack {
        EventDetailView(eventID: Event.samples[0].id)
            .environmentObject(EventStore())
    }
}


