//
//  ContentView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 15.12.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var session = Session.shared
    
    var body: some View {
        VStack {
            switch session.currentScreen {
                case .login:
                    LoginView()
                case .register:
                    RegisterView()
                case .adminAccount:
                    AdminMainView()
                case .studentAccount:
                    StudentMainView(student: session.user as! Student)
                case .teamDirectorAccount:
                    TeamDirectorMainView()
            }
        }
        .transition(.opacity)
        .animation(.bouncy, value: session.currentScreen)
    }
}

#Preview {
    ContentView()
}
