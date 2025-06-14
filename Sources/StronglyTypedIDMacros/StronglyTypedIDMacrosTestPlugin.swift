//
//  StronglyTypedIDMacrosTestPlugin.swift
//  StronglyTypedID
//
//  Created by Óscar Morales Vivó on 6/8/25.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct StronglyTypedIDMacrosTestPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FreestandingStronglyTypedIDMacro.self,
        AttachedStronglyTypedIDMacro.self
    ]
}
