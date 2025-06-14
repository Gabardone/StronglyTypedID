import StronglyTypedID
import XCTest

final class StronglyTypedIDTests: XCTestCase {
    // As of Xcode 16.4 this line below causes a warning about `any Comparable` requirement.
    // Other protocols do not cause this issue, this might be a compiler glitch but unclear of which kind.
    @StronglyTypedID<Int>
    struct DummyIDType: Comparable {}

    // Mostly testing that the Swift type system does what we expect.
    func testComparableStronglyTypedID() {
        let dummyID1 = DummyIDType(rawValue: 7)
        let dummyID2 = DummyIDType(rawValue: 77)

        XCTAssert(dummyID1 < dummyID2)
    }

    struct PersonName: Hashable, Codable {
        var firstName: String

        var lastName: String
    }

    // Testing using a non-trivial value type as an ID type.
    func testComplexStronglyTypedID() {
        struct Person {
            #StronglyTypedID<PersonName>("ID")

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

        XCTAssertNotEqual(john.id, mary.id)
    }
}

/// We just throw the docs clown stuff here to make sure it actually builds.
protocol Performer {
    var hourlyWage: Decimal { get }

    // ...
}

protocol PerformerID: StronglyTypedID {}

struct Clown: Identifiable, Performer {
    @StronglyTypedID<UUID> struct ID: PerformerID {}

    var id: ID

    let hourlyWage = Decimal(7.25)

    // ...
}

struct Acrobat: Identifiable {
    @StronglyTypedID<UUID> struct ID: PerformerID {}

    var id: ID

    let hourlyWage = Decimal(50.00)

    // ...
}

protocol Payroll {
    func pay(performer: some PerformerID, period: TimeInterval) -> Decimal

    // ...
}
