//
//  ContentView.swift
//  SwiftToMermaid
//
//  Created by Barry Press on 7/9/24.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Loading diagram...")
            } else {
                WebViewWrapper(webView: viewModel.webView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: .openFile, object: nil, queue: .main) { notification in
                openFile()
            }
            viewModel.generateMermaidImage()
        }
    }

    func openFile() {
#if os(macOS)
        let dialog = NSOpenPanel()

        dialog.title                   = "Choose file to diagram"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = true
        dialog.allowedContentTypes     = [.swiftSource]

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let contents = dialog.urls.compactMap {fileURL in try? String(contentsOf: fileURL, encoding: .utf8)}.joined(separator: "\n")
            viewModel.generateMermaidImage(swiftContent: contents)
        } else {
            print("User cancelled the dialog")
        }
#else
        // Implement file opening logic for iOS if needed
        fatalError("Open File action triggered on iOS")
#endif
    }
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
