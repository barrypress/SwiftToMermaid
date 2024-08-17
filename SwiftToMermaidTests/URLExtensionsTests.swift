//
//  URLExtensionsTests.swift
//  SwiftToMermaidTests
//
//  Created by Barry Press on 8/19/24.
//

import Testing
import Foundation

@testable import SwiftToMermaid

@Suite("URLExtensionsTests", .serialized)
class URLExtensionsTestsSuite {
    let temp = FileManager.default.temporaryDirectory.absoluteString
    var directory: URL!
    var file: URL!

    @discardableResult
    fileprivate func initializeFile(_ ext: String, content: String = "data in file for unit tests") -> URL {
        file = directory.appendingPathComponent("file_for_unit_tests").appendingPathExtension(ext)
        if (try? content.write(to: file, atomically: true, encoding: .utf8)) == nil {
            precondition(false, "Failed to create file for unit tests")
        }
        return file
    }
    
    init() {
        if directory == nil {
            directory = FileManager.default.temporaryDirectory.appendingPathComponent("URLExtensionsTests")
            if !FileManager.default.fileExists(atPath: directory.path) {
                try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }
            precondition(FileManager.default.fileExists(atPath: directory.path), "Failed to create directory for unit tests")
        }
        initializeFile("text")
    }

    deinit {
        if let file = file, FileManager.default.fileExists(atPath: file.path) {
            try? FileManager.default.removeItem(at: file)
        }
    }

    @Test
    func testIsHidden() {
        // Set isHidden to true
        do {
            var resourceValues = URLResourceValues()
            resourceValues.isHidden = true
            try file.setResourceValues(resourceValues)

            // Retrieve the isHidden property
            let retrievedResourceValues = try file.resourceValues(forKeys: [.isHiddenKey])
            let isHidden = retrievedResourceValues.isHidden ?? false
            #expect(isHidden)
        } catch {
            #expect(Bool(false), "setResourceValues threw \(error.localizedDescription)")
        }
    }

    @Test
    func testIsNotHidden() {
        var resourceValues = URLResourceValues()
        resourceValues.isHidden = false
        #expect((try? file.setResourceValues(resourceValues)) != nil)
        #expect(!file.isHidden)
    }

    @Test
    func testCleanedAbsoluteString() {
        #expect(file.cleanedAbsoluteString == file.path)
    }

    @Test
    func testCleanedLastPathComponent() {
        #expect(file.cleanedLastPathComponent == "file_for_unit_tests.text")
    }

    @Test
    func testIsRegularFile() {
        #expect(file.isRegularFile)
    }

    @Test
    func testIsDirectory() {
        #expect(directory.isDirectory)
    }

    @Test
    func testTextTypeIdentifier() {
        initializeFile("text")
        print("file =", file as Any)
        print("file.urlTypeIdentifierString() =", file.urlTypeIdentifierString() as Any)
        print("UTI(rawValue: urlTypeIdentifierString() =", UTI(rawValue: file.urlTypeIdentifierString() ?? "nil") as Any)
        print("file.typeIdentifier =", file.typeIdentifier)
        print("file.typeIdentifier.rawValue =", file.typeIdentifier.rawValue)
        #expect(file.typeIdentifier.rawValue == "public.plain-text")
    }

    @Test
    func testSwiftTypeIdentifier() {
        initializeFile("swift")
        print("file =", file as Any)
        print("file.urlTypeIdentifierString() =", file.urlTypeIdentifierString() as Any)
        print("UTI(rawValue: urlTypeIdentifierString() =", UTI(rawValue: file.urlTypeIdentifierString() ?? "nil") as Any)
        print("file.typeIdentifier =", file.typeIdentifier)
        print("file.typeIdentifier.rawValue =", file.typeIdentifier.rawValue)
        #expect(file.typeIdentifier.rawValue == "public.swift-source")
    }


    @Test
    func testSwiftTypeIdentifierList() {
        typealias Tuple = (ext: String, uti: String, content: String?)
        for tuple: Tuple in [
            ("gif", "com.compuserve.gif", nil),
            ("gzip", "org.gnu.gnu-zip-archive", nil),
            ("heic", "public.heic", nil),
            ("html", "public.html", nil),
            ("jpeg", "public.jpeg", nil),
            ("json", "public.json", nil),
            ("markdown", "net.daringfireball.markdown", nil),
            ("md", "net.daringfireball.markdown", nil),
            ("pdf", "com.adobe.pdf", nil),
            ("plist", "com.apple.property-list", nil),
            ("png", "public.png", nil),
            ("swift", "public.swift-source", "class Foo {var bar: Int = 0}"),
            ("tar", "public.tar-archive", nil),
            ("txt", "public.plain-text", nil),
            ("text", "public.plain-text", nil),
            ("tiff", "public.tiff", nil),
            ("xml", "public.xml", nil),
            ("zip", "public.zip-archive", nil),
        ] {
            let content = tuple.content ?? "data in file for unit tests"
            let file = initializeFile(tuple.ext, content: content)
            if file.typeIdentifier.rawValue != tuple.uti { reportFile(file) }
        }

        func reportFile(_ file: URL) {
            let ext = file.pathExtension
            let uti = UTI(rawValue: file.urlTypeIdentifierString() ?? "nil")?.name ?? "Can't get UTI"
            let content = (try? String(contentsOf: file)) ?? "<<< Read Failed >>>"
            fflush(stdout)
            print("\next =", ext, ", uti =", uti)
            print("file                                    =", file)
            print("content                                 = \"\(content)\"")
            print("file.urlTypeIdentifierString()          =", file.urlTypeIdentifierString() as Any)
            print("UTI(rawValue: urlTypeIdentifierString() =", UTI(rawValue: file.urlTypeIdentifierString() ?? "nil") as Any)
            print("file.typeIdentifier                     =", file.typeIdentifier)
            print("file.typeIdentifier.rawValue            =", file.typeIdentifier.rawValue)
            #expect(file.typeIdentifier.rawValue == uti)
            print("\n")
        }
    }

    @Test
    func testUrlTypeIdentifierString() {
        #expect(file.urlTypeIdentifierString() == "public.plain-text")
    }
}
