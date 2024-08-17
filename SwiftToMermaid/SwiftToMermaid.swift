import Foundation
import SourceKittenFramework

// Struct to hold class information
struct ClassOrStructInfo {
    let name: String
    var properties: [String] = []
    var methods: [String] = []
    var inheritsFrom: String?
}

// Function to extract class information from a SourceKitten structure
func extractClassOrStructInfo(structure: [String: SourceKitRepresentable]) -> [ClassOrStructInfo] {
    var classes: [ClassOrStructInfo] = []
    guard let kind = structure["key.kind"] as? String else { return []}

    if kind == "source.lang.swift.decl.class" || kind == "source.lang.swift.decl.struct" {
        var classInfo = ClassOrStructInfo(name: structure["key.name"] as! String)

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
            classes.append(contentsOf: extractClassOrStructInfo(structure: substructure))
        }
    }

    return classes
}

/// Function to parse Swift code and return Mermaid class diagram code
///
/// The ability to make this work seems to be critically dependent on the structure of the returned HTML.
/// Specifically, it was necessary to have the leading spaces for `classDiagram`, but not too many of them.
/// - Parameter swiftCode: Text of a .swift file
/// - Returns: Text of the equivalent mermaid diagram. Not real useful for structs
func generateMermaidDiagram(from swiftCode: String) -> String {
    let fileContent = File(contents: swiftCode)
    let structure = try! Structure(file: fileContent)
    var classesAndStructs: [ClassOrStructInfo] = []

    for substructure in structure.dictionary["key.substructure"] as! [[String: SourceKitRepresentable]] {
        classesAndStructs.append(contentsOf: extractClassOrStructInfo(structure: substructure))
    }

    var mermaidCode = "  classDiagram\n"

    if !classesAndStructs.isEmpty {
        for info in classesAndStructs {
            mermaidCode += "    class \(info.name) {\n"
            for property in info.properties {
                mermaidCode += "        \(property)\n"
            }
            for method in info.methods {
                mermaidCode += "        \(method)\n"
            }
            mermaidCode += "    }\n"
            if let inheritsFrom = info.inheritsFrom {
                mermaidCode += "    \(inheritsFrom) <|-- \(info.name)\n"
            }
        }
    } else {
        mermaidCode += "    class NoClassesOrStructsInFile\n"
    }

    return mermaidCode
}
