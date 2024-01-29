//
//  MyTeamViewForTeamDirector.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.01.2024.
//

import SwiftUI

struct MyTeamViewForTeamDirector: View {
    @State var teamInformation: GeneralInformation? = nil
    @State var students = [Student]()
    @StateObject var session: Session
    @State var isEditingModalPresented = false
    
    var body: some View {
        VStack {
            if let information = teamInformation {
                GeneralInformationView(information: information)
                
                MyTeamTable(students: students)
                HStack {
                    Spacer()
                    
                    EditButton(action: editTeam, name: "Изменить команду")
                }
            } else {
                VStack {
                    Text("Вы не состоите в команде😢")
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                    
                    AddButton(action: editTeam, name: "Хочу в команду😋")
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            loadData()
        }
        .sheet(isPresented: $isEditingModalPresented,
               onDismiss: {
            loadData()
        }, content: {
            EditingUserTeamView(session: session, cancelAction: cancel)
        })
    }
    
    private func cancel() {
        isEditingModalPresented = false
    }
    
    private func editTeam() {
        isEditingModalPresented = true
    }
    
    private func loadData() {
        do {
            teamInformation = try Service.shared.fetchTeamDirectorTeam(with: session.userID)
        } catch {}
    }
}

