//
//  Extensions.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.01.2024.
//

import Foundation
import SwiftUI

extension String {
    var isNumber: Bool {
        return self.range(
            of: "^[0-9]*$",
            options: .regularExpression) != nil
    }
}

extension String {
    var isContainsOnlyRussianCharacters: Bool {
        return self.range(
            of: "^[а-яА-Я ]*$",
            options: .regularExpression) != nil
    }
}

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
