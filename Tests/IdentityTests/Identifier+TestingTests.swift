//
//  Identifier+TestingTests.swift
//
//
//  Created by Óscar Morales Vivó on 3/21/23.
//

import Identity
import Testing

struct Identifier_TestingTests {
    // Not really testing much of anything but verifying that the type system wrangling produces the desired result.
    // If the extension of `TestStringIDType` adopting `ExpressibleByStringLiteral` is removed the test won't compile.
    @Test func expressibleByStringLiteralID() {
        // This only builds if TestStringIDType is declared as adopting `ExpressibleByStringLiteral`
        let dummyID1: TestStringIDType = "Potato"

        #expect(dummyID1 == "Potato")

        // This only builds if TestStringIDType is declared as adopting `ExpressibleByStringInterpolation`
        let dummyID2: TestStringIDType = "Another \(dummyID1)"

        #expect(dummyID2 == "Another Potato")
    }
}

struct TestStringIDType: Identifier, Comparable {
    var rawValue: String
}

extension TestStringIDType: ExpressibleByStringLiteral {}

extension TestStringIDType: ExpressibleByStringInterpolation {}
