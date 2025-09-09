//
//  TaskManagerMVVMApp.swift
//  TaskManagerMVVM
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//
import SwiftUI

@main
struct TaskManagerMVVMApp: App {
    @StateObject private var viewModel = TaskListViewModel()
    
    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environmentObject(viewModel) // VM’i tüm alt view’lara dağıt
        }
    }
}
