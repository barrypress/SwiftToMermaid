//
//  URL+Extensions.swift
//  SwiftToMermaid
//
//  Created by Barry Press on 8/19/24.
//

import Foundation

extension URL: @retroactive Comparable {
    public static func < (lhs: URL, rhs: URL) -> Bool {
        lhs.path < rhs.path
    }
    
    var xisHidden: Bool {
        var isHiddenResourceValue: URLResourceValues?
        isHiddenResourceValue = try? self.resourceValues(forKeys: [.isHiddenKey])
        if let isHidden = isHiddenResourceValue?.isHidden {
            return isHidden}
        return isHiddenResourceValue?.isHidden ?? false
    }

    /// `true` is hidden (invisible) or `false` is not hidden (visible)
    var isHidden: Bool {
        get {
            let result = try? resourceValues(forKeys: [.isHiddenKey]).isHidden
            return result == true
        }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.isHidden = newValue
            do {
                try setResourceValues(resourceValues)
            } catch {
                print("isHidden error:", error)
            }
        }
    }

    var cleanedAbsoluteString: String {absoluteString.replacingOccurrences(of: "file://", with: "").replacingOccurrences(of: "%20", with: " ")}
    var cleanedLastPathComponent: String {lastPathComponent.replacingOccurrences(of: "%20", with: " ")}

    var isRegularFile: Bool {
        let fileAttributes = try? self.resourceValues(forKeys:[.isRegularFileKey])
        return fileAttributes?.isRegularFile ?? false
    }

    var isDirectory: Bool {
        let fileAttributes = try? self.resourceValues(forKeys:[.isDirectoryKey])
        return fileAttributes?.isDirectory ?? false
    }
    
    /// The resource’s uniform type identifier (UTI), returned as a UTI case, returning .unknown if the type identifier cannot be determined.
    ///
    /// Useful forms of the returned string include string are typically of the form `"public.text"` or `"public.swift-source"` or `"public.folder"`
    var typeIdentifier: UTI {UTI(rawValue: urlTypeIdentifierString() ?? "") ?? .unknown}

    /// The resource’s uniform type identifier (UTI), returned as an NSString or nil if the type identifier cannot be determined. Use .typeIdentifier to get an empty string
    /// if the type identifier cannot be determined.
    /// - Returns: A string typically of the form `"public.text"` or `"public.swift-source"` or `"public.folder"`
    func urlTypeIdentifierString() -> String? {
        do {
            let fileAttributes = try self.resourceValues(forKeys: [.typeIdentifierKey])
//            print("File Attributes: \(fileAttributes)")
            return fileAttributes.typeIdentifier
        } catch {
            print("Failed to retrieve file attributes: \(error)")
            return nil
        }
    }
}

enum UTI: String {
    //        case directory = "public.folder"
    case folder = "public.folder"
    case gif = "com.compuserve.gif"
    case gzip = "org.gnu.gnu-zip-archive"
    case heic = "public.heic"
    case html = "public.html"
    case image = "public.png"
    case jpeg = "public.jpeg"
    case json = "public.json"
    case markdown = "net.daringfireball.markdown"
    case pdf = "com.adobe.pdf"
    case plist = "com.apple.property-list"
    case swiftSource = "public.swift-source"
    case tar = "public.tar-archive"
    case text = "public.plain-text"
    case tiff = "public.tiff"
    //        case txt = "public.plain-text"
    case xml = "public.xml"
    case zip = "public.zip-archive"

    case unknown = ""

    var name: String {rawValue.replacingOccurrences(of: "public.", with: "")}
}
