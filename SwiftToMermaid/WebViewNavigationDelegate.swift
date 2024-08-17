//
//  WebViewNavigationDelegate.swift
//  SwiftToMermaid
//
//  Created by Barry Press on 7/22/24.
//

#if os(iOS)
import UIKit
typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit
typealias PlatformImage = NSImage
#endif

import SwiftUI
import WebKit

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    let completion: (PlatformImage?) -> Void

    init(completion: @escaping (PlatformImage?) -> Void) {
        self.completion = completion
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.takeSnapshot(with: nil) { image, error in
            self.completion(image)
        }
    }
}
