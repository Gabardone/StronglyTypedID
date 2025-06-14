//
//  FreestandingStronglyTypedIDMacro.swift
//
//
//  Created by Óscar Morales Vivó on 9/20/23.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct FreestandingStronglyTypedIDMacro {}

// MARK: - DeclarationMacro Adoption

extension FreestandingStronglyTypedIDMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in _: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let parameters = node.arguments
        guard parameters.count == 1 else {
            // This should only happen due to toolset error or out of sync macro declaration so let's blow up.
            preconditionFailure("Unexpected argument count \(parameters.count). Toolset shouldn't have made it this far")
        }

        // Get the ID type name from the first parameter.
        let typeName = extractStringArgument(parameters[parameters.startIndex])

        guard let generics = node.genericArgumentClause else {
            preconditionFailure("Unexpectedly there are no generic arguments")
        }

        guard generics.arguments.count >= 1 else {
            preconditionFailure("Unexpected generic count \(generics.arguments.count). Toolset shouldn't have made it this far")
        }

        // Grab the backing type.
        let backingIndex = generics.arguments.startIndex
        let backingTypeName = generics.arguments[backingIndex].argument.as(IdentifierTypeSyntax.self)!

        // No adoptions, let's just return and build.
        let result =
            """
            struct \(typeName): StronglyTypedID {
                var rawValue: \(backingTypeName)
            }
            """
        return ["\(raw: result)"]
    }

    private static func extractStringArgument(_ argument: LabeledExprSyntax) -> String {
        if let stringLiteral = argument.expression.as(StringLiteralExprSyntax.self) {
            "\(stringLiteral.segments)"
        } else {
            // We're only supposed to call this with `StaticString` parameters, so if we're here it's toolset error or
            // out of sync macro declaration.
            preconditionFailure("Unexpected argument, toolset should only allow `StaticString` literals in")
        }
    }

    private static func extractTypeArgument(_ argument: ExprSyntax) -> String {
        let memberAccess = argument.as(MemberAccessExprSyntax.self)
        let declName = argument.as(DeclReferenceExprSyntax.self)

        if let memberAccess, memberAccess.declName.baseName.text == "self" {
            if let name = memberAccess.base?.description {
                return name
            } else {
                preconditionFailure("No backing type specified")
            }
        } else if let declName {
            return declName.baseName.text
        } else {
            preconditionFailure("Arguments specifying types must be in the form of `T.self`")
        }
    }
}
