//
//  UserProtocol.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 07.01.2024.
//

import Foundation

protocol UserProtocol: Hashable {
    var id: Int { get set }
    var name: String { get set }
    var surname: String { get set }
    var patronymic: String? { get set }
    var birthdate: Date? { get set }
    var phone: String { get set }
}
