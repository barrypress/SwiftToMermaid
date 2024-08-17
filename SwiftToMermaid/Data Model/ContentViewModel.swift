//
//  ContentViewModel.swift
//  SwiftToMermaid
//
//  Created by Barry Press on 7/22/24.
//

import SwiftUI
import WebKit

class ContentViewModel: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var isLoading: Bool = true
    var webView: WKWebView!

    override init() {
        super.init()
        self.webView = WKWebView(frame: .zero)
        self.webView.navigationDelegate = self
    }
    
    /// Generate the corresponding mermaid description from swift code.
    /// - Parameter swiftContent: The text to be processed. It gets processed by SourceKitten. Multiple
    /// files can be concatenated.
    func generateMermaidImage(swiftContent: String = "class foo: NSObject {}") {
        isLoading = true
        let classes = generateMermaidDiagram(from: swiftContent)
        let mermaidHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <script type="module">
                import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
                mermaid.initialize({ startOnLoad: true });
            </script>
        </head>
        <body>
            <div class="mermaid">
        \(classes)
            </div>
        </body>
        </html>
        """
        webView.loadHTMLString(mermaidHTML, baseURL: nil)
        isLoading = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
