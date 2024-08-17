//
//  ContentViewModelTests.swift
//  ContentViewModelTests
//
//  Created by Barry Press on 7/20/24.
//

import Testing
import WebKit
@testable import SwiftToMermaid

@MainActor
@Suite("ContentViewModelTests", .serialized)
struct ContentViewModelTests {
    class Delegate: NSObject, WKNavigationDelegate {
        let instance: ContentViewModelTests!

        init(instance: ContentViewModelTests) {
            self.instance = instance
        }

        // Required for WKNavigationDelegate protocol
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.instance.viewModel?.isLoading = false
            }
        }
    }

    var delegate: Delegate!
    var viewModel: ContentViewModel!

    init() {
        delegate = nil
        delegate = Delegate(instance: self)
        setUp()
    }

    mutating func setUp() {
        viewModel = ContentViewModel()
        viewModel.webView.navigationDelegate = delegate
    }

    mutating func tearDown() {
        viewModel = nil
    }

    @Test
    func testInitialLoadingState() {
        #expect(viewModel.isLoading, "Initial loading state should be true")
    }

    @Test
    func testGenerateMermaidImage() {
        viewModel.generateMermaidImage()
        #expect(!self.viewModel.isLoading, "Loading state should be false after loading HTML")
    }
}
