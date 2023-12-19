//
//  TeamDirector.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.12.2023.
//

import Foundation

struct TeamDirector: Identifiable {
    var id: Int
    var name: String
    var surname: String
    var patronymic: String
    var birthdate: Date?
    var phone: String
    var team: Team?
    
    var fullName: String { surname + " " + name + " " + patronymic }
}
