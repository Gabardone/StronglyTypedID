//
//  IdentityMacrosTests.swift
//
//
//  Created by Óscar Morales Vivó on 9/21/23.
//

import Foundation
import Identity
import SwiftDiagnostics
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling.
// Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(IdentityMacros)
@testable import IdentityMacros

let testFreestandingMacros: [String: Macro.Type] = [
    "Identifier": FreestandingIdentifierMacro.self
]

let testAttachedMacros: [String: Macro.Type] = [
    "Identifier": AttachedIdentifierMacro.self
]
#endif

protocol SomeProtocol {}

protocol SomeOtherProtocol {}

struct IdentifierMacroTests {
    // Not quite a unit test but a check that the macro actually expands.
    @Test func buildSimpleFreestandingMacro() throws {
        struct TestStruct: Identifiable {
            // Declaration has to happen in a different scope than creation. Within a local `struct` works.
            #Identifier<UUID>("TestID")

            var id: TestID
        }

        // If this builds we're good.
        _ = TestStruct.TestID.unique()
    }

    private static var canRunMacroTests: Bool {
        #if canImport(IdentityMacros)
        return true
        #else
        return false
        #endif
    }

    @Test(.enabled(if: canRunMacroTests)) func freestandingMacroExpansion() throws {
        #if canImport(IdentityMacros)
        assertMacroExpansion(
            """
            #Identifier<UUID>(\"ID\")
            """,
            expandedSource: """
            struct ID: Identifier {
                var rawValue: UUID
            }
            """,
            macros: testFreestandingMacros
        )
        #endif
    }

    @Test(.enabled(if: canRunMacroTests)) func attachedMacroSimpleUseExpansion() throws {
        #if canImport(IdentityMacros)
        assertMacroExpansion(
            """
            @Identifier<UUID>
            public struct ImageID: ResourceID, FileID, MediaID {}
            """,
            expandedSource: """
            public struct ImageID: ResourceID, FileID, MediaID {

                public init(rawValue: UUID) {
                    self.rawValue = rawValue
                }

                public typealias RawValue = UUID

                public var rawValue: UUID
            }

            extension ImageID: Identifier {
            }
            """,
            macros: testAttachedMacros
        )
        #endif
    }

    @Test(.enabled(if: canRunMacroTests)) func attachedMacroWithExtraAdoptions() throws {
        #if canImport(IdentityMacros)
        assertMacroExpansion(
            """
            @Identifier<UUID> struct ImageID: ResourceID, FileID, MediaID {}
            """,
            expandedSource: """
            struct ImageID: ResourceID, FileID, MediaID {

                init(rawValue: UUID) {
                    self.rawValue = rawValue
                }

                typealias RawValue = UUID

                var rawValue: UUID
            }

            extension ImageID: Identifier {
            }
            """,
            macros: testAttachedMacros
        )
        #endif
    }
}

// Type declared here to verify that attached macro actually works.
//
// Cannot be used in a local type.
struct TestStruct: Identifiable {
    @Identifier<UUID> struct TestID: SomeProtocol, SomeOtherProtocol {}

    var id: TestID
}
