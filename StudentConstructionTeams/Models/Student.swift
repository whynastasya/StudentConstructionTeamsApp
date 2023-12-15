//
//  Student.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.12.2023.
//

import Foundation

struct Student: Identifiable {
    var id: Int
    var name: String
    var surname: String
    var patronymic: String
    var birthdate: Date?
    var earnings: Int = 0
    var phone: String
    var password: String
    var isElder: Bool = false
    var groupID: Int
    var group: String?
    var teamID: Int?
    var team: String?
    
    let uuid = UUID()
    
    var fullName: String { surname + " " + name + " " + patronymic }
}

var students =
    [Student(id: 1, name: "Настасья", surname: "Григорчук", patronymic: "Тимофеевна", birthdate: Date(), earnings: 23456, phone: "89260819584", password: "говно", isElder: true, groupID: 2, group: "02-21", teamID: 7),
     Student(id: 2, name: "Настасья", surname: "Григорчук", patronymic: "Тимофеевна", birthdate: Date(), earnings: 23456, phone: "89260819584", password: "говно", isElder: true, groupID: 2, teamID: 7, team: "Котята"),
     Student(id: 3, name: "Настасья", surname: "Григорчук", patronymic: "", earnings: 23456, phone: "89260819584", password: "говно", isElder: true, groupID: 2, teamID: 7)]
