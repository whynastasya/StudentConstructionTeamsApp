//
//  Screen.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 06.01.2024.
//

import Foundation

final class Session: ObservableObject {
    @Published var currentScreen: Screen = .login
    @Published var user: any UserProtocol
    
    static var shared = Session(currentScreen: .register, user: User(id: 0, name: "", surname: "", patronymic: "", phone: ""))
    
    private init(currentScreen: Screen, user: any UserProtocol) {
        self.currentScreen = currentScreen
        self.user = user
    }
    
    enum Screen {
        case login
        case register
        case adminAccount
        case studentAccount
        case teamDirectorAccount
    }
}
