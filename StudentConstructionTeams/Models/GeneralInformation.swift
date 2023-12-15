//
//  GeneralInformation.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 15.12.2023.
//

import Foundation

struct GeneralInformation {
    var name: String?
    var elder: Person?
    var director: Person?
    var taskType: String?
    var date: Date?
    var countStudent: Int?
    
    struct Person {
        var name: String
        var phone: String
    }
}
