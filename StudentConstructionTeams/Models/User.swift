//
//  Users.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import Foundation

struct User: UserProtocol, Identifiable {
    var id: Int
    var name: String
    var surname: String
    var patronymic: String
    var birthdate: Date?
    var phone: String
    
    var fullName: String { surname + " " + name + " " + patronymic }
}
