//
//  Sidebar.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct StudentMainView: View {
    @State var student = Student(id: 0, userID: 0, name: "", surname: "", phone: "")
    @StateObject var session: Session
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: MyAccountView(session: session)) {
                    AccountViewInSidebar(session: session)
                }
                
                NavigationLink(destination: MyTeamView(session: session)) {
                    HStack {
                        Image("my_team_icon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Моя команда")
                    }
                }
                
                NavigationLink(destination: MyGroupView(session: session)) {
                    HStack {
                        Image("my_group_icon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Моя группа")
                    }
                }
                NavigationLink(destination: TasksView()) {
                    HStack {
                        Image("my_earnings_icon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Мой заработок")
                    }
                }
            }
        } detail: {
            MyTeamView(session: session)
        }
        .navigationTitle("Строительные отряды")
        .onAppear {
            do {
                if let student = try Service.service.fetchStudent(with: session.userID) {
                    self.student = student
                } else {
                    session.currentScreen = .login
                    session.userID = 0
                }
            } catch {
                
            }
        }
    }
}
