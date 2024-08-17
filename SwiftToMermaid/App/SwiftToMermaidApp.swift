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

                Menu("Open Recent") {
                    let paths = RecentFilesManager.shared.recentFiles
                    ForEach(paths, id: \.self) { path in
                        Button(pathToFilename(path)) {
                            NotificationCenter.default.post(name: .openRecent, object: path)
                        }
                            .keyboardShortcut(pathShortcut(for: path, in: paths), modifiers: .command)
                    }
                }
            }
        }
    }

    func pathShortcut(for path: String, in paths: [String]) -> KeyEquivalent {
        let keyEquivalent: KeyEquivalent
        if let index = paths.firstIndex(of: path) {
            keyEquivalent = KeyEquivalent(Character("\(index + 1)"))
        } else {
            keyEquivalent = "0"
        }
        return keyEquivalent
    }

    func pathToFilename(_ path: String) -> String {
        let fileName = URL(fileURLWithPath: path).cleanedLastPathComponent
        return fileName
    }
}
