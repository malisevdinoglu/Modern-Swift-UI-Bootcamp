//
//  ContentView.swift
//  MasterListApp
//
//  Created by Mehmet Ali Sevdinoğlu on 6.09.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: ListViewModel

    @State private var showAddSheet = false
    @State private var useAltView   = false
    @State private var tint: Color  = .blue

    private let themeColors: [Color] = [.blue, .green, .orange, .pink, .purple, .teal, .red, .indigo, .mint, .cyan]

    var body: some View {
        NavigationStack {
            Group {
                if useAltView {
                    // Alternatif görünüm: ScrollView + LazyVStack
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {

                            if !vm.pendingItems.isEmpty {
                                Text("Tamamlanacaklar")
                                    .font(.title3).bold()
                                    .padding(.top, 8)

                                ForEach(vm.pendingItems) { item in
                                    NavigationLink {
                                        DetailView(item: item)
                                    } label: {
                                        AltRow(item: item)
                                    }
                                    .contextMenu {
                                        Button(item.isDone ? "Geri Al" : "Tamamla") {
                                            vm.toggle(item)
                                        }
                                        Button(role: .destructive) {
                                            vm.delete(item)
                                        } label: {
                                            Text("Sil")
                                        }
                                    }
                                }
                            }

                            if !vm.doneItems.isEmpty {
                                Text("Tamamlananlar")
                                    .font(.title3).bold()
                                    .padding(.top, 8)

                                ForEach(vm.doneItems) { item in
                                    NavigationLink {
                                        DetailView(item: item)
                                    } label: {
                                        AltRow(item: item)
                                    }
                                    .contextMenu {
                                        Button("Geri Al") { vm.toggle(item) }
                                        Button(role: .destructive) {
                                            vm.delete(item)
                                        } label: {
                                            Text("Sil")
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                    }
                } else {
                    // Klasik List görünümü: swipe-to-delete + swipe actions
                    List {
                        if !vm.pendingItems.isEmpty {
                            Section("Tamamlanacaklar") {
                                ForEach(vm.pendingItems) { item in
                                    NavigationLink {
                                        DetailView(item: item)
                                    } label: {
                                        Row(item: item)
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            vm.delete(item)
                                        } label: {
                                            Label("Sil", systemImage: "trash")
                                        }
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            vm.toggle(item)
                                        } label: {
                                            Label("Tamamla", systemImage: "checkmark")
                                        }
                                        .tint(.green)
                                    }
                                }
                                .onDelete(perform: vm.deletePending) // sola kaydırıp sil
                            }
                        }

                        if !vm.doneItems.isEmpty {
                            Section("Tamamlananlar") {
                                ForEach(vm.doneItems) { item in
                                    NavigationLink {
                                        DetailView(item: item)
                                    } label: {
                                        Row(item: item)
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            vm.delete(item)
                                        } label: {
                                            Label("Sil", systemImage: "trash")
                                        }
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            vm.toggle(item)
                                        } label: {
                                            Label("Geri Al", systemImage: "arrow.uturn.backward")
                                        }
                                        .tint(.blue)
                                    }
                                }
                                .onDelete(perform: vm.deleteDone)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("MasterListApp")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Label("Ekle", systemImage: "plus.circle.fill")
                    }
                    .accessibilityLabel("Yeni öğe ekle")
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Toggle(isOn: $useAltView) {
                        Text("Alternatif")
                    }
                    .toggleStyle(.switch)
                    .accessibilityLabel("Alternatif görünüm")
                }
            }
            .sheet(isPresented: $showAddSheet) {
                NewItemView()
                    .presentationDetents([.medium, .large])
            }
        }
        .tint(tint) // Rastgele tema rengi
        .onAppear {
            if let newTint = themeColors.randomElement() {
                tint = newTint
            }
        }
    }
}

// MARK: - Satır görünümleri
private struct Row: View {
    let item: TodoItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                .imageScale(.large)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(.headline)
                Text(item.detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

private struct AltRow: View {
    let item: TodoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(item.title).font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
            }
            Text(item.detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Divider()
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
