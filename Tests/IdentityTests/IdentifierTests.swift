//
//  IdentifierTests.swift
//
//
//  Created by Óscar Morales Vivó on 3/21/23.
//

import Foundation
import Identity
import Testing

struct IdentifierTests {
    @Identifier<Int>
    struct DummyIDType: Comparable {}

    // Mostly testing that the Swift type system does what we expect.
    @Test func comparableIdentifierBehavesAsExpected() {
        let dummyID1 = DummyIDType(rawValue: 7)
        let dummyID2 = DummyIDType(rawValue: 77)

        #expect(dummyID1 < dummyID2)
    }

    struct PersonName: Hashable, Codable {
        var firstName: String

        var lastName: String
    }

    // Testing using a non-trivial value type as an ID type.
    @Test func complexIdentifierWorks() {
        struct Person {
            #Identifier<PersonName>("ID")

            var id: ID {
                .init(rawValue: .init(firstName: firstName, lastName: lastName))
            }

            var firstName: String

            var lastName: String

            var isCool: Bool

            var hasTheRizz: Bool
        }

        let john = Person(firstName: "John", lastName: "Doe", isCool: false, hasTheRizz: false)
        let mary = Person(firstName: "Mary", lastName: "Sue", isCool: false, hasTheRizz: true)

        #expect(john.id != mary.id)
    }
}

/// We just throw the docs clown stuff here to make sure it actually builds.
protocol Performer {
    var hourlyWage: Decimal { get }

    // ...
}

protocol PerformerID: Identifier {}

struct Clown: Identifiable, Performer {
    @Identifier<UUID> struct ID: PerformerID {}

    var id: ID

    let hourlyWage = Decimal(7.25)

    // ...
}

struct Acrobat: Identifiable {
    @Identifier<UUID> struct ID: PerformerID {}

    var id: ID

    let hourlyWage = Decimal(50.00)

    // ...
}

protocol Payroll {
    func pay(performer: some PerformerID, period: TimeInterval) -> Decimal

    // ...
}
