//
//  MyGroupView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct MyGroupView: View {
    @StateObject var session: Session
    @State var groupInformation: GeneralInformation? = nil
    @State var students = [Student]()
    @State var isEditingModalPresented = false
    
    var body: some View {
        VStack {
            if let information = groupInformation {
                GeneralInformationView(information: information)
                MyGroupTable(students: students)
                HStack {
                    Spacer()
                    
                    EditButton(action: editGroup, name: "Изменить группу")
                }
            } else {
                Text("Вы не состоите в группе😢")
                    .fontDesign(.rounded)
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                
                AddButton(action: editGroup, name: "Выбрать свою группу😇")
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
            EditingStudentGroup(session: session, cancelAction: cancel)
        })
    }
    
    private func editGroup() {
        isEditingModalPresented = true
    }
    
    private func loadData() {
        do {
            groupInformation = try Service.shared.fetchStudentGroup(with: session.userID)
            students = try Service.shared.fetchGroupmates(with: session.userID)
        } catch { }
    }
    
    private func cancel() {
        isEditingModalPresented = false
    }
}
