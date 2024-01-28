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
            }
        } detail: {
            UsersAdminView(session: session)
        }
        .navigationTitle("Строительные отряды")
    }
}

