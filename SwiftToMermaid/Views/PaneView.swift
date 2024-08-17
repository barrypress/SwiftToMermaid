//
//  PaneView.swift
//  SwiftToMermaid
//
//  Created by Barry Press on 7/9/24.
//

import SwiftUI
import WebKit

struct PaneView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var title: String = "SwiftToMermaid"

    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Loading diagram...")
            } else {
                WebViewWrapper(webView: viewModel.webView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(title)
        .onAppear {
            NotificationCenter.default.addObserver(forName: .openFile, object: nil, queue: .main) { _ in
                openFile()
            }
            NotificationCenter.default.addObserver(forName: .openRecent, object: nil, queue: .main) { notification in
                if let path = notification.object as? String {
                    processFiles(at: [path])
                }
            }
            viewModel.generateMermaidImage()
        }
    }

    func openFile() {
#if os(macOS)
        let dialog = NSOpenPanel()

        dialog.title                   = "Choose file or directory to diagram"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = true
        dialog.canChooseFiles          = true
        dialog.canChooseDirectories    = true
        dialog.allowedContentTypes     = [.swiftSource, .directory]

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let files = dialog.urls.map {url in url.cleanedAbsoluteString}
            processFiles(at: files)
        } else {
            print("User cancelled the dialog")
        }
#else
        fatalError("Open File action triggered on iOS")
#endif
    }

    func setupTitle(title: String) -> String {
        self.title = URL(fileURLWithPath: title).lastPathComponent
        return title
    }

    @discardableResult
    private func processFiles(at paths: [String]) -> String {
        guard !paths.isEmpty else {return setupTitle(title: "SwiftToMermaid")}
        RecentFilesManager.shared.addRecentFile(paths[0])
        let contents = paths.map {filePath in URL(fileURLWithPath: filePath).absoluteURL}
                            .compactMap {url in pathContents(url: url)}
                            .joined(separator: "\n")
        viewModel.generateMermaidImage(swiftContent: contents/*.replacingOccurrences(of: "struct", with: "class")*/)
        return setupTitle(title: paths[0])
    }

    typealias URLTuple = (directories: [URL], files: [URL])
    func pathContents(url: URL) -> String? {
        let pathsResult: URLTuple = pathsToFiles(at: url,
                                                 recursion: true,
                                                 type: [.swiftSource],
                                                 properties: [.isRegularFileKey, .isDirectoryKey, .isHiddenKey])
        assert(pathsResult.directories.count == 0, dmessage("Recursion option also returned directories", pathsResult))
        var content: [String] = []
        for fileURL in pathsResult.files.sorted(by: <) {
            if let fileContent = try? String(contentsOf: fileURL, encoding: .utf8) {
                content.append(fileContent)
            }
        }
        return content.joined(separator: "\n")
//
//        switch url {
//            case let url where url.hasDirectoryPath:
//                assert(pathsResult.directories.count > 0)
//                let items = try? FileManager().contentsOfDirectory(atPath: url.path).sorted()
//                return items?.compactMap { (urlItem) -> String? in
//                    let fileURL = url.appendingPathComponent(urlItem)
//                    guard !fileURL.isHidden else {return nil}
//                    return try? String(contentsOf: fileURL, encoding: .utf8)
//                }.joined(separator: "\n")
//            case let url where url.isFileURL:
//                return [.swiftSource].contains(url.typeIdentifier)
//                ? try? String(contentsOf: url, encoding: .utf8)
//                : nil
//            default:
//                return nil
//        }
    }
    
    /// Process a path to determine the contents of the path meeting criteria and return that contents split into directories and files.
    ///
    /// If `recursion` is true, a deep search is performed and only regular file paths are returned. Otherwise, the returned paths
    /// may include both directories and files. No directories are returned when recursion is true.
    /// - Parameters:
    ///   - url: Where to search
    ///   - recursion: Whether to search subdirectories.
    ///   - type: The kinds of files desired, such as [.swift-source]
    ///   - properties: The filter for files to be examined
    ///   - options: The options given to FileManager.enumerator
    /// - Returns: a tuple of directories and files
    func pathsToFiles(at url: URL,
                      recursion: Bool,
                      type: [UTI] = [],
                      properties: [URLResourceKey] = [.isRegularFileKey, .isDirectoryKey, .isHiddenKey],
                      options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants]) -> URLTuple {
        var directories = [URL]()
        var files = [URL]()
        if !url.isDirectory {
            return (directories, [url])
        } else if let enumerator = FileManager.default.enumerator(at: url,
                                                                  includingPropertiesForKeys: properties,
                                                                  options: options) {
            for case let fileURL as URL in enumerator {
                if fileURL == url || fileURL.isHidden {
                    continue
                } else if fileURL.isDirectory {
                    if recursion {
                        files += pathsToFiles(at: fileURL, recursion: true, type: type, properties: properties).files
                    } else {
                        directories.append(fileURL)
                    }
                } else if check(fileURL: fileURL, type: [.swiftSource]) {
                    files.append(fileURL)
//                } else {
//                    print("Not a file", fileURL)
                }
            }
        }
        return (directories, files)
    }

    /// Verify a given file, known to not be a directory, meets the criteria for inclusion in the results.
    /// - Parameter fileURL: The file to check
    /// - Returns: true iff the file meets the criteria
    func check(fileURL: URL, type: [UTI]) -> Bool {fileURL.isRegularFile && (type.isEmpty || type.contains(fileURL.typeIdentifier))}
}

struct WebViewWrapper: NSViewRepresentable {
    var webView: WKWebView

    func makeNSView(context: Context) -> WKWebView {
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // No update logic needed for now
    }
}

#Preview {
    ContentView()
}
