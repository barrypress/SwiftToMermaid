//
//  SwiftToMermaidApp.swift
//  SwiftToMermaid
//
//  Created by Barry Press on 7/20/24.
//

import SwiftUI
import UniformTypeIdentifiers

@main
struct SwiftToMermaidApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Open...") {
                    NotificationCenter.default.post(name: .openFile, object: nil)
                }
                .keyboardShortcut("O", modifiers: .command)
            }
        }
    }
}
