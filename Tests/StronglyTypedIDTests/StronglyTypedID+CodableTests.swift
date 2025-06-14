//
//  StronglyTypedID+CodableTests.swift
//
//
//  Created by Óscar Morales Vivó on 3/21/23.
//

import StronglyTypedID
import XCTest

// swiftlint:disable nesting
final class StronglyTypedID_CodableTests: XCTestCase {
    // Tests that `String`-based Strongly typed IDs will encode/decode as just a plain string. Very useful for backend
    // ID decoding...
    func testStringIDCodable() throws {
        struct DataStruct: Identifiable, Codable {
            struct ID: StronglyTypedID {
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

        XCTAssertEqual(dataStruct.id.rawValue, decodedData.id)
        XCTAssertEqual(dataStruct.dataString, decodedData.dataString)
        XCTAssertEqual(dataStruct.dataInteger, decodedData.dataInteger)
    }

    // Tests that `URL`-based Strongly typed IDs will encode/decode as just a plain string. Very useful for backend ID
    // decoding...
    func testURLIDCodable() throws {
        struct DataStruct: Identifiable, Codable {
            struct ID: StronglyTypedID {
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

        XCTAssertEqual(dataStruct.id.rawValue.absoluteString, decodedData.id)
        XCTAssertEqual(dataStruct.dataString, decodedData.dataString)
        XCTAssertEqual(dataStruct.dataInteger, decodedData.dataInteger)
    }

    // Tests that `UUID`-based Strongly typed IDs will encode/decode as just a plain string. Very useful for backend ID
    // decoding...
    func testUUIDCodable() throws {
        struct DataStruct: Identifiable, Codable {
            struct ID: StronglyTypedID {
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

        XCTAssertEqual(dataStruct.id.rawValue, UUID(uuidString: decodedData.id))
        XCTAssertEqual(dataStruct.dataString, decodedData.dataString)
        XCTAssertEqual(dataStruct.dataInteger, decodedData.dataInteger)
    }

    // Tests that `Int`-based Strongly typed IDs will encode/decode as just a plain string. Very useful for backend ID
    // decoding...
    func testIntegerIDCodable() throws {
        struct DataStruct: Identifiable, Codable {
            struct ID: StronglyTypedID {
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

        XCTAssertEqual(dataStruct.id.rawValue, dumbID)
        XCTAssertEqual(dataStruct.dataString, decodedData.dataString)
        XCTAssertEqual(dataStruct.dataInteger, decodedData.dataInteger)
    }

    // Tests that `Float`-based Strongly typed IDs will encode/decode as just a plain string. Very useful for backend ID
    // decoding...
    func testFloatIDCodable() throws {
        struct DataStruct: Identifiable, Codable {
            struct ID: StronglyTypedID {
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

        XCTAssertEqual(dataStruct.id.rawValue, dumbID)
        XCTAssertEqual(dataStruct.dataString, decodedData.dataString)
        XCTAssertEqual(dataStruct.dataInteger, decodedData.dataInteger)
    }
}

// swiftlint:enable nesting
