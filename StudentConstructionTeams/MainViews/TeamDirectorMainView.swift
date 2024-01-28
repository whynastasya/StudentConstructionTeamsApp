//
//  TeamDirectorMainView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 06.01.2024.
//

import SwiftUI

struct TeamDirectorMainView: View {
    @State var teamDirector = TeamDirector(id: 0, userID: 0, name: "", surname: "", phone: "")
    @StateObject var session: Session
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: MyAccountView(session: session)) {
                    AccountViewInSidebar(session: session)
                }
                
                NavigationLink(destination: MyTeamViewForTeamDirector(session: session)) {
                    HStack {
                        Image("my_team_icon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Моя команда")
                    }
                }
                
                NavigationLink(destination: TasksView()) {
                    HStack {
                        Image("my_earnings_icon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Задачи")
                    }
                }
            }
        } detail: {
            MyTeamViewForTeamDirector(session: session)
        }
        .navigationTitle("Строительные отряды")
        .onAppear {
            do {
                if let teamDirector = try Service.service.fetchTeamDirector(with: session.userID) {
                    self.teamDirector = teamDirector
                } else {
                    session.currentScreen = .login
                    session.userID = 0
                }
            } catch { }
        }
    }
}
