//
//  AttachedStronglyTypedIDMacro.swift
//  StronglyTypedID
//
//  Created by Óscar Morales Vivó on 6/8/25.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct AttachedStronglyTypedIDMacro {}

// MARK: - DeclarationMacro Adoption

extension AttachedStronglyTypedIDMacro: MemberMacro {
    public static func expansion(
        of _: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo _: [TypeSyntax],
        in _: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let attributeListElement = declaration.attributes.first,
              case let .attribute(attribute) = attributeListElement,
              let genericClause = attribute.attributeName.as(IdentifierTypeSyntax.self)?.genericArgumentClause,
              let genericParam = genericClause.arguments.first
        else {
            // This should only happen due to toolset error or out of sync macro declaration so let's blow up.
            preconditionFailure("Unable to find macro declaration, somehow.")
        }

        let access = declaration.modifiers.first(where: \.isNeededAccessLevelModifier)

        return [
            "\(access)init(rawValue: \(genericParam)) { self.rawValue = rawValue }",
            "\(access)typealias RawValue = \(genericParam)",
            "\(access)var rawValue: \(genericParam)"
        ]
    }
}

extension AttachedStronglyTypedIDMacro: ExtensionMacro {
    public static func expansion(
        of _: AttributeSyntax,
        attachedTo _: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo _: [TypeSyntax],
        in _: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        // This is all simple enough.
        let stronglyTypedIDConformance = try ExtensionDeclSyntax("extension \(type.trimmed): StronglyTypedID {}")

        return [stronglyTypedIDConformance]
    }
}

private extension DeclModifierSyntax {
    var isNeededAccessLevelModifier: Bool {
        switch name.tokenKind {
        case .keyword(.public): true
        default: false
        }
    }
}
