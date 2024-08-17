import Foundation
import SourceKittenFramework

// Struct to hold class information
struct ClassInfo {
    let name: String
    var properties: [String] = []
    var methods: [String] = []
    var inheritsFrom: String?
}

// Function to extract class information from a SourceKitten structure
func extractClassInfo(structure: [String: SourceKitRepresentable], classes: inout [ClassInfo]) {
    guard let kind = structure["key.kind"] as? String else { return }

    if kind == "source.lang.swift.decl.class" {
        var classInfo = ClassInfo(name: structure["key.name"] as! String)

        if let inheritedTypes = structure["key.inheritedtypes"] as? [[String: SourceKitRepresentable]],
           let inheritedType = inheritedTypes.first {
            classInfo.inheritsFrom = inheritedType["key.name"] as? String
        }

        if let substructures = structure["key.substructure"] as? [[String: SourceKitRepresentable]] {
            for substructure in substructures {
                if let subKind = substructure["key.kind"] as? String {
                    if subKind == "source.lang.swift.decl.var.instance" {
                        classInfo.properties.append("+ \(substructure["key.name"] as! String)")
                    } else if subKind == "source.lang.swift.decl.function.method.instance" {
                        classInfo.methods.append("+ \(substructure["key.name"] as! String)()")
                    }
                }
            }
        }

        classes.append(classInfo)
    }

    if let substructures = structure["key.substructure"] as? [[String: SourceKitRepresentable]] {
        for substructure in substructures {
            extractClassInfo(structure: substructure, classes: &classes)
        }
    }
}

/// Function to parse Swift code and return Mermaid class diagram code
///
/// The ability to make this work seems to be critically dependent on the structure of the returned HTML.
/// Specifically, it was necessary to have the leading spaces for `classDiagram`, but not too many of them.
/// - Parameter swiftCode: Text of a .swift file
/// - Returns: Text of the equivalent mermaid diagram. Not real useful for structs
func generateMermaidClassDiagram(from swiftCode: String) -> String {
    let fileContent = File(contents: swiftCode)
    let structure = try! Structure(file: fileContent)
    var classes: [ClassInfo] = []

    for substructure in structure.dictionary["key.substructure"] as! [[String: SourceKitRepresentable]] {
        extractClassInfo(structure: substructure, classes: &classes)
    }

    var mermaidCode = "  classDiagram\n"

    if !classes.isEmpty {
        for classInfo in classes {
            mermaidCode += "    class \(classInfo.name) {\n"
            for property in classInfo.properties {
                mermaidCode += "        \(property)\n"
            }
            for method in classInfo.methods {
                mermaidCode += "        \(method)\n"
            }
            mermaidCode += "    }\n"
            if let inheritsFrom = classInfo.inheritsFrom {
                mermaidCode += "    \(inheritsFrom) <|-- \(classInfo.name)\n"
            }
        }
    } else {
        mermaidCode += "    class NoClassesInFile\n"
    }

    return mermaidCode
}
