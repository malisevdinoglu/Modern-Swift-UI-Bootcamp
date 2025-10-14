//
//  SwiftNotesWidgetBundle.swift
//  SwiftNotesWidget
//
//  Created by Mehmet Ali Sevdinoğlu on 14.10.2025.
//

import WidgetKit
import SwiftUI

@main
struct SwiftNotesWidgetBundle: WidgetBundle {
    var body: some Widget {
        SwiftNotesWidget()
        SwiftNotesWidgetControl()
    }
}
