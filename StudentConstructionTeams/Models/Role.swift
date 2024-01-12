//
//  Role.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.01.2024.
//

import Foundation

enum Role {
    case admin(User.ID), student(User.ID), teamDirector(User.ID)
}
