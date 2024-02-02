//
//  AdminMainView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 06.01.2024.
//

import SwiftUI

struct AdminMainView: View {
    @StateObject var session: Session
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: MyAccountView(session: session)) {
                    AccountViewInSidebar(session: session)
                }
                
                NavigationLink(destination: UsersAdminView(session: session)) {
                    HStack {
                        Image(systemName: "person.3.sequence.fill")
                            .resizable()
                            .frame(width: 22, height: 12)
                        
                        Text("Пользователи")
                    }
                }
                
                NavigationLink(destination: UserTypesAdminView(session: session)) {
                    HStack {
                        Image(systemName: "person.crop.rectangle.stack")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Типы пользователей")
                    }
                }
                
                NavigationLink(destination: GroupsAdminView(session: session)) {
                    HStack {
                        Image(systemName: "shared.with.you")
                            .resizable()
                            .frame(width: 20, height: 18)
                        
                        Text("Студенческие группы")
                    }
                }
                
                NavigationLink(destination: TaskTypesAdminView(session: session)) {
                    HStack {
                        Image(systemName: "list.bullet.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Типы заданий")
                    }
                }
                
                NavigationLink(destination: TaskStatusesAdminView(session: session)) {
                    HStack {
                        Image(systemName: "gauge.with.needle")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Статусы выполнения заданий")
                    }
                }
                
                NavigationLink(destination: TasksAdminView(session: session)) {
                    HStack {
                        Image(systemName: "checklist")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("Задачи")
                    }
                }
                
                NavigationLink(destination: TeamDirectorsAdminView(session: session)) {
                    HStack {
                        Image(systemName: "figure.and.child.holdinghands")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Руководители")
                    }
                }
                
                NavigationLink(destination: StudentsAdminView(session: session)) {
                    HStack {
                        Image(systemName: "graduationcap.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Студенты")
                    }
                }
                
                NavigationLink(destination: TeamsAdminView(session: session)) {
                    HStack {
                        Image(systemName: "circle.grid.2x2.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Команды")
                    }
                }
                
                NavigationLink(destination: StayingInTeamAdminView(session: session)) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .resizable()
                            .frame(width: 20, height: 18)
                        
                        Text("Пребывания в команде")
                    }
                }
            }
        } detail: {
            UsersAdminView(session: session)
        }
        .navigationTitle("Строительные отряды")
    }
}

