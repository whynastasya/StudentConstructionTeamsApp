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
    @Published var selectedCellID: Int?
    
    init(currentScreen: Screen, userID: Int, selectedCellID: Int?) {
        self.currentScreen = currentScreen
        self.userID = userID
        self.selectedCellID = selectedCellID
    }
}
