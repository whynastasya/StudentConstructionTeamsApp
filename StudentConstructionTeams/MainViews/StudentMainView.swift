//
//  Sidebar.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct StudentMainView: View {
    @State var student: Student
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: MyAccountView()) {
                    AccountViewInSidebar(user: student, accountType: "Студент")
                }
                
                NavigationLink(destination: MyTeamView()) {
                    HStack {
                        Image("my_team_icon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Моя команда")
                    }
                }
                
                NavigationLink(destination: MyGroupView()) {
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
            
        }
        .navigationTitle("Строительные отряды")
    }
}
