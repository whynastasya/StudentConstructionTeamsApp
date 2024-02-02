//
//  StayingInTeam.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import Foundation

struct StayingInTeam: Identifiable {
    var id: Int
    var team: Team
    var student: Student
    var startDate: Date
    var endDate: Date?
}
