//
//  ContentView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 15.12.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var session = Session(currentScreen: .register, user: User(id: 0, name: "", surname: "", patronymic: "", phone: ""))
    
    var body: some View {
        VStack {
            switch session.currentScreen {
                case .login:
                    LoginView(session: session)
                case .register:
                    RegisterView(session: session)
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
