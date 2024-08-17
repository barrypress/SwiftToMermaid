//
//  RecentFilesManager.swift
//  SwiftToMermaid
//
//  Created by Barry Press on 8/20/24.
//

import SwiftUI

class RecentFilesManager {
    static let shared = RecentFilesManager()

    private let recentFilesKey = "recentFiles"
    private let maxRecentFiles = 10

    var recentFiles: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: recentFilesKey) ?? []
        }
        set {
            UserDefaults.standard.set(Array(newValue.prefix(maxRecentFiles)), forKey: recentFilesKey)
        }
    }

    func addRecentFile(_ file: String) {
        let name = URL(fileURLWithPath: file).lastPathComponent
        var files = recentFiles
        while let index = files.firstIndex(where: {URL(fileURLWithPath: $0).lastPathComponent == name}) {
            files.remove(at: index)
        }
        files.insert(file, at: 0)
        recentFiles = files
    }
}
