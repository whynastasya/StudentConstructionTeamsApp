//
//  EditingUserTeam.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 13.01.2024.
//

import SwiftUI

struct EditingUserTeam: View {
    @StateObject var session: Session
    @State var selectedTeam: Team.ID = 0
    @State var teams: [Team]?
    var cancelAction: () -> Void
    @State private var successResult = false
    
    var body: some View {
        VStack {
            Text("Редактирование")
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.accent)
            
            if successResult {
                Text("Данные команды пользователя изменены")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            Picker("Выберите команду", selection: $selectedTeam) {
                Text("Нет команды").tag(0)
                ForEach(teams ?? [Team](), id: \.self) { team in
                    Text(team.name).tag(team.id)
                }
            }
            .fontDesign(.rounded)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
            
            HStack {
                CancelButton(action: cancelAction)
                EditButton(action: editUserTeam)
            }
        }
        .padding()
        .background(.black.opacity(0.2))
        .animation(.easeInOut, value: successResult)
        .frame(minWidth: 350, minHeight: 210)
        .onAppear {
            do {
                if session.currentScreen == .studentAccount {
                    teams = try Service.service.fetchAllTeams()
                } else if session.currentScreen == .teamDirectorAccount {
                    teams = try Service.service.fetchFreeTeamsForTeamDirector(with: session.userID)
                }
            } catch { }
        }
    }
    
    func editUserTeam() {
        do {
            try Service.service.updateUserTeam(userID: session.userID, teamID: selectedTeam, typeUser: session.currentScreen)
        } catch { }
        successResult = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            cancelAction()
        }
    }
}
