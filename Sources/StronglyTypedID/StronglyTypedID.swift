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
public protocol StronglyTypedID: RawRepresentable, Codable, CustomStringConvertible, Hashable
    where RawValue: Codable, RawValue: Hashable {}

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

 - Parameters
   - name: The name of the new ID type. Must be a valid type identifier at compile time.
   - backing: The type that backs the ID type, its `rawValue`
   - adopts: Optionally, a comma separated list of protocols that the ID type also adopts.
 */
@freestanding(declaration, names: arbitrary)
public macro StronglyTypedID<T, each U>(_ name: StaticString, backing: T.Type, adopts: repeat (each U).Type) = #externalMacro(
    module: "StronglyTypedIDMacros",
    type: "StronglyTypedIDMacro"
)
