//
//  Task.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.12.2023.
//

import Foundation

struct ConstructionTask: Identifiable {
    let id: Int
    
    var taskType: TaskType
    var countHours: String
    var status: TaskStatus
    var team: Team?
    var startDate: Date?
    var endDate: Date?
}
