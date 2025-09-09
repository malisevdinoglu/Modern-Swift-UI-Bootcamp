//
//  Date+Format.swift
//  EventFlow
//
//  Created by Mehmet Ali Sevdinoğlu on 9.09.2025.
//

import Foundation

extension Date {
    static var tomorrow: Date { Calendar.current.date(byAdding: .day, value: 1, to: Date())! }

    func formattedShort() -> String {
        formatted(date: .abbreviated, time: .omitted)
    }
}
