//
//  MyTeamView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 19.12.2023.
//

import SwiftUI

struct MyTeamViewForStudent: View {
    @State var teamInformation: GeneralInformation? = nil
    @State var currentTaskInformation: GeneralInformation? = nil
    @State var students = [Student]()
    @StateObject var session: Session
    @State var isEditingModalPresented = false
    
    var body: some View {
        VStack {
            if let information = teamInformation {
                GeneralInformationView(information: information)
                
                if let information = currentTaskInformation {
                    GeneralInformationView(information: information)
                } else {
                    Text("Заданий нет")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background()
                        .clipShape(.rect(cornerRadius: 20))
                }
                
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
            EditingUserTeam(session: session, cancelAction: cancel)
        })
    }
    
    private func editTeam() {
        isEditingModalPresented = true
    }
    
    private func cancel() {
        isEditingModalPresented = false
    }
    
    private func loadData() {
        do {
            teamInformation = try Service.service.fetchStudentTeam(with: session.userID)
            currentTaskInformation = try Service.service.fetchUserCurrentTask(userID: session.userID)
            students = try Service.service.fetchTeammates(userID: session.userID)
        } catch { }
    }
}
