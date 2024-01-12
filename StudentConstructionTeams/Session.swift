//
//  Screen.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 06.01.2024.
//

import Foundation

final class Session: ObservableObject {
    @Published var currentScreen: Screen = .login
    @Published var userID: Int
    
    init(currentScreen: Screen, userID: Int) {
        self.currentScreen = currentScreen
        self.userID = userID
    }
    
    enum Screen {
        case login
        case register
        case adminAccount
        case studentAccount
        case teamDirectorAccount
    }
}
