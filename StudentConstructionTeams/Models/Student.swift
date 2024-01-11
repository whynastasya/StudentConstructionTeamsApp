//
//  Student.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.12.2023.
//

import Foundation

struct Student: UserProtocol, Identifiable {
    var id: Int
    var userID: Int
    var name: String
    var surname: String
    var patronymic: String?
    var birthdate: Date?
    var earnings: Int = 0
    var phone: String
    var isElder: Bool = false
    var group: Group?
    var team: Team?
    
    var fullName: String { surname + " " + name + " " + (patronymic ?? "") }
}


