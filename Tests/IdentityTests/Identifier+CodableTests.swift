//
//  Identifier+CodableTests.swift
//
//
//  Created by Óscar Morales Vivó on 3/21/23.
//

import Identity
import Testing
import XCTest

// swiftlint:disable nesting
struct Identifier_CodableTests {
    // Tests that `String`-based identifier will encode/decode as just a plain string. Very useful for backend ID
    // decoding...
    @Test func stringIDEncodesDecodesAsString() throws {
        struct DataStruct: Identifiable, Codable {
            struct ID: Identifier {
                var rawValue: String
            }

            var id: ID

            var dataString: String

            var dataInteger: Int
        }

        let dataStruct = DataStruct(id: .init(rawValue: "Potato"), dataString: "I like pie", dataInteger: 7777)

        let encoder = JSONEncoder()

        let encodedData = try encoder.encode(dataStruct)

        // We decode into a simpler type to verify that the ID was encoded as just its raw value.
        struct DummyStruct: Codable {
            var id: String

            var dataString: String

            var dataInteger: Int
        }

        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(DummyStruct.self, from: encodedData)

        #expect(dataStruct.id.rawValue == decodedData.id)
        #expect(dataStruct.dataString == decodedData.dataString)
        #expect(dataStruct.dataInteger == decodedData.dataInteger)
    }

    // Tests that `URL`-based identifier will encode/decode as just a plain string. Very useful for backend ID
    // decoding...
    @Test func urlIDCodableEncodesAndDecodesAsPlainString() throws {
        struct DataStruct: Identifiable, Codable {
            struct ID: Identifier {
                var rawValue: URL
            }

            var id: ID

            var dataString: String

            var dataInteger: Int
        }

        let dataStruct = DataStruct(
            id: .init(rawValue: URL(string: "https://zombo.com/")!),
            dataString: "I like pie",
            dataInteger: 7777
        )

        let encoder = JSONEncoder()

        let encodedData = try encoder.encode(dataStruct)

        // We decode into a simpler type to verify that the ID was encoded as just its string raw value.
        struct DummyStruct: Codable {
            var id: String

            var dataString: String

            var dataInteger: Int
        }

        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(DummyStruct.self, from: encodedData)

        #expect(dataStruct.id.rawValue.absoluteString == decodedData.id)
        #expect(dataStruct.dataString == decodedData.dataString)
        #expect(dataStruct.dataInteger == decodedData.dataInteger)
    }

    // Tests that `UUID`-based identifeir will encode/decode as just a plain string. Very useful for backend ID
    // decoding...
    @Test func uuidCodableEncodesDecodesAsLowercaseString() throws {
        struct DataStruct: Identifiable, Codable {
            struct ID: Identifier {
                var rawValue: UUID
            }

            var id: ID

            var dataString: String

            var dataInteger: Int
        }

        let uuid = UUID()
        let dataStruct = DataStruct(
            id: .init(rawValue: uuid),
            dataString: "I like pie",
            dataInteger: 7777
        )

        let encoder = JSONEncoder()

        let encodedData = try encoder.encode(dataStruct)

        // We decode into a simpler type to verify that the ID was encoded as just its string raw value.
        struct DummyStruct: Codable {
            var id: String

            var dataString: String

            var dataInteger: Int
        }

        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(DummyStruct.self, from: encodedData)

        #expect(dataStruct.id.rawValue == UUID(uuidString: decodedData.id))
        #expect(dataStruct.id.rawValue.uuidString.lowercased() == decodedData.id)
        #expect(dataStruct.dataString == decodedData.dataString)
        #expect(dataStruct.dataInteger == decodedData.dataInteger)
    }

    // Tests that `Int`-based identifier will encode/decode as just a plain integer. Very useful for backend ID
    // decoding...
    @Test func integerIDCodableEncodesDecodesAsInteger() throws {
        struct DataStruct: Identifiable, Codable {
            struct ID: Identifier {
                var rawValue: UInt64
            }

            var id: ID

            var dataString: String

            var dataInteger: Int
        }

        let dumbID = UInt64(12345)
        let dataStruct = DataStruct(
            id: .init(rawValue: dumbID),
            dataString: "I like pie",
            dataInteger: 7777
        )

        let encoder = JSONEncoder()

        let encodedData = try encoder.encode(dataStruct)

        // We decode into a simpler type to verify that the ID was encoded as just its integer value.
        struct DummyStruct: Codable {
            var id: Int

            var dataString: String

            var dataInteger: Int
        }

        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(DummyStruct.self, from: encodedData)

        #expect(dataStruct.id.rawValue == dumbID)
        #expect(dataStruct.dataString == decodedData.dataString)
        #expect(dataStruct.dataInteger == decodedData.dataInteger)
    }

    // Tests that `Float`-based identifier will encode/decode as just a plain floating point value. Very useful
    // for backend ID decoding...
    @Test func floatIDCodableEncodesDecodesAsFloat() throws {
        struct DataStruct: Identifiable, Codable {
            struct ID: Identifier {
                var rawValue: Double
            }

            var id: ID

            var dataString: String

            var dataInteger: Int
        }

        let dumbID = 3.141592
        let dataStruct = DataStruct(
            id: .init(rawValue: dumbID),
            dataString: "I like pie",
            dataInteger: 7777
        )

        let encoder = JSONEncoder()

        let encodedData = try encoder.encode(dataStruct)

        // We decode into a simpler type to verify that the ID was encoded as just its integer value.
        struct DummyStruct: Codable {
            var id: Double

            var dataString: String

            var dataInteger: Int
        }

        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(DummyStruct.self, from: encodedData)

        #expect(dataStruct.id.rawValue == dumbID)
        #expect(dataStruct.dataString == decodedData.dataString)
        #expect(dataStruct.dataInteger == decodedData.dataInteger)
    }
}

// swiftlint:enable nesting
