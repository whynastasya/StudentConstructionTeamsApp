//
//  Extensions.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.01.2024.
//

import Foundation

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
            of: "^[а-яА-Я]*$",
            options: .regularExpression) != nil
    }
}
