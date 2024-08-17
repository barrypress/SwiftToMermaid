// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SwiftToMermaid",
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "0.50300.0"),
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.32.0") // Added missing dependency
    ],
    targets: [
        .target(
            name: "SwiftToMermaid",
            dependencies: ["SourceKittenFramework", "SwiftSyntax"]) // Ensured dependencies are listed
    ]
)
