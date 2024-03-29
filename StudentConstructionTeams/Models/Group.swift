//
//  Group.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.12.2023.
//

import Foundation

struct Group: Identifiable, Hashable {
    var id: Int
    var name: String
    var faculty: String
    var elderID: Int?
}
