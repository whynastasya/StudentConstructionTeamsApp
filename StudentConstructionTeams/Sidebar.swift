//
//  Sidebar.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct Sidebar: View {
    @State var user = User(id: 1, name: "Nastasya", surname: "Grigorchuk", patronymic: "Timofeevna", phone: "")
    @State var userType = "Student"
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: MyAccountView()) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        VStack {
                            Text(user.surname + " " + user.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(userType)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.gray)
                        }
                    }
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

#Preview {
    Sidebar()
}
