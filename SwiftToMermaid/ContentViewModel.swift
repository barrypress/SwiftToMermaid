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

    func generateMermaidImage(swiftContent: String = "class foo: NSObject {}") {
        let classes = generateMermaidClassDiagram(from: swiftContent)
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
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}

/*
import SwiftUI
import WebKit

class ContentViewModel: ObservableObject {
    @Published var mermaidImage: PlatformImage?
    var webView: WKWebView
    var webViewNavigationDelegate: WebViewNavigationDelegate! = nil

    init() {
        webView = WKWebView(frame: .zero)
        webViewNavigationDelegate = WebViewNavigationDelegate { image in
            self.mermaidImage = image
        }
        webView.navigationDelegate = webViewNavigationDelegate
    }

    func generateMermaidImage(diagram: String = "graph TD; A-->B; A-->C; B-->D; C-->D;") {
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
            graph TD; A-->B; A-->C; B-->D; C-->D;
                <div class="mermaid">
                    graph TD; A-->B; A-->C; B-->D; C-->D;
                </div>
            </body>
            </html>
            """
        webView.loadHTMLString(mermaidHTML, baseURL: nil)
    }
}
*/

/*
 The linked code snippet is a JavaScript app:

    var _____WB$wombat$assign$function_____ = function(name) {return (self._wb_wombat && self._wb_wombat.local_init && self._wb_wombat.local_init(name)) || self[name]; };
    if (!self.__WB_pmw) { self.__WB_pmw = function(obj) { this.__WB_source = obj; return this; } }
    {
    let window = _____WB$wombat$assign$function_____("window");
    let self = _____WB$wombat$assign$function_____("self");
    let document = _____WB$wombat$assign$function_____("document");
    let location = _____WB$wombat$assign$function_____("location");
    let top = _____WB$wombat$assign$function_____("top");
    let parent = _____WB$wombat$assign$function_____("parent");
    let frames = _____WB$wombat$assign$function_____("frames");
    let opener = _____WB$wombat$assign$function_____("opener");

    import { b6 as f } from "./mermaid-a09fe7cd.js";
    export {
    f as default
    };

 */
