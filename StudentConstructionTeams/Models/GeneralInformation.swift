//
//  GeneralInformation.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 15.12.2023.
//

import Foundation

struct GeneralInformation {
    var groupName: String?
    var teamName: String?
    var elder: Person?
    var director: Person?
    var taskType: TaskType?
    var startDate: Date?
    var countStudents: Int?
    var allEarnings: Int?
    var currentMonthEarnings: Int?
    
    struct Person {
        var name: String
        var phone: String
    }
}
