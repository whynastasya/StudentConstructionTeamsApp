//
//  ContentView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 15.12.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var session = Session(currentScreen: .login, user: User(id: 0, name: "", surname: "", phone: "", userType: UserType(id: 0, name: "")))
    
    var body: some View {
        VStack {
            switch session.currentScreen {
                case .login:
                    LoginView(session: session)
                case .register:
                    RegisterView(session: session)
                case .adminAccount:
                    AdminMainView(session: session)
                case .studentAccount:
                    StudentMainView(student: session.user as! Student, session: session)
                case .teamDirectorAccount:
                    TeamDirectorMainView(session: session)
            }
        }
        .transition(.opacity)
        .animation(.bouncy, value: session.currentScreen)
    }
}

#Preview {
    ContentView()
}
