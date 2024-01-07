//
//  ContentView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 15.12.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var currentScreen = Screen()
    
    var body: some View {
        VStack {
            switch currentScreen.currentScreen {
                case .login:
                    LoginView(currentScreen: currentScreen)
                case .register:
                    RegisterView(currentScreen: currentScreen)
                case .adminAccount:
                    AdminMainView()
                case .studentAccount:
                    StudentMainView()
                case .teamDirectorAccount:
                    TeamDirectorMainView()
            }
        }
        .transition(.opacity)
        .animation(.bouncy, value: currentScreen.currentScreen)
    }
}

#Preview {
    ContentView()
}
