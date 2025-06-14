//
//  StronglyTypedID.swift
//
//
//  Created by Óscar Morales Vivó on 3/21/23.
//

import Foundation

/**
 A protocol for easy declaration of strongly typed ID types based on typical primitive values.

 The protocol groups all the expected ease of dev use behaviors so the ID can be used as dictionary keys,
 encoded/decoded, and logged or reported out as just its raw value.

 The protocol has been tested work with `RawValue` as a `String`, `URL`, `UUID`, and integer types. Floating point
 types should work as long as encoding/decoding doesn't lose precision (it's probably not a good idea to use them for
 anything that isn't strictly local).
 */
public protocol StronglyTypedID: RawRepresentable, Codable, CustomStringConvertible, Hashable, Sendable
    where RawValue: Codable & Hashable & Sendable {}

public extension StronglyTypedID {
    /**
     Strongly typed IDs use only their raw values for their conversion to strings. This makes them easy to use as values
     passed to logging and reporting methods.
     */
    var description: String {
        String(describing: rawValue)
    }
}

/**
 Most of the time IDs shouldn't be comparable, but if it convenient or required this default implementation will take
 care of the matter. You still need to declare it on your specific ID type as `MyIDType: Comparable`.
 */
public extension StronglyTypedID where Self: Comparable, RawValue: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/**
 A macro that declares a strongly typed ID.

 Use this macro when you just need an ID that has no further sophistication beyond what this package offers.
 - Parameters
   - name: The name of the new ID type. Must be a valid type identifier at compile time.
   - backing: The type that backs the ID type, its `rawValue`
   - adopts: Optionally, a comma separated list of protocols that the ID type also adopts. Currently Swift doesn't allow
 for a declaration that would check that the parameters sent are as described, but the expanded macro will fail to build
 if any of the parameters isn't a protocol.
 */
@freestanding(declaration, names: arbitrary)
public macro StronglyTypedID<Backing: Hashable & Codable & Sendable>(_ name: StaticString) = #externalMacro(
    module: "StronglyTypedIDMacros",
    type: "FreestandingStronglyTypedIDMacro"
)

/**
 A macro that makes a declared type into a strongly typed ID.

 The macro also deals with conformance of `RawRepresentable` by adding the appropiate `typealias` and stored property.

 You can use this macro for any ID types where you may need to implement some of the methods yourself or otherwise
 extend their functionality, add stored properties and add nontrivial conformances.
 */
@attached(member, names: named(RawValue), named(rawValue), named(init(rawValue:)))
@attached(extension, conformances: StronglyTypedID)
public macro StronglyTypedID<Backing: Hashable & Codable & Sendable>() = #externalMacro(
    module: "StronglyTypedIDMacros",
    type: "AttachedStronglyTypedIDMacro"
)
