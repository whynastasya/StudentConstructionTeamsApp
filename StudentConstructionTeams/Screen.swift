//
//  Screen.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 06.01.2024.
//

import Foundation

class Screen: ObservableObject {
    @Published var currentScreen: Screen = .register
    
    enum Screen {
        case login
        case register
        case adminAccount
        case studentAccount
        case teamDirectorAccount
    }
}
