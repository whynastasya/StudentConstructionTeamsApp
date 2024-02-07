//
//  TeamSummary.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 06.02.2024.
//

import Foundation

struct TeamSummary: Identifiable {
    var id: Int
    var teamName: String
    var studentsCount: Int
    var averageEarnings: Int?
    var latestStayStart: Date?
}
