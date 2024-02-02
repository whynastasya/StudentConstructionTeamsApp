//
//  StayingInTeamAdminView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 02.02.2024.
//

import SwiftUI

struct StayingInTeamAdminView: View {
    @StateObject var session: Session
    @State private var stayingInTeams = [StayingInTeam]()
    @State private var isEditingModalPresented = false
    @State private var isAddingModalPresented = false
    @State private var isDeletingModalPresented = false
    @State private var selectedStayingInTeam = StayingInTeam(id: 0, team: Team(id: 0, name: "", countStudents: 0), student: Student(id: 0, userID: 0, name: "", surname: "", phone: ""), startDate: Date())
    
    var body: some View {
        VStack {
            VStack {
                Text("Пребыввание студентов в командах")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                StayingInTeamAdminTable(session: session, stayingInTeam: stayingInTeams)
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
            
            HStack {
                Spacer()
                AddButton(action: { isAddingModalPresented = true })
                EditButton(action: { isEditingModalPresented = true })
                    .disabled(((session.selectedCellID?.description.isEmpty) == nil))
                DeleteButton(action: { isDeletingModalPresented = true })
                    .disabled(((session.selectedCellID?.description.isEmpty) == nil))
                    .foregroundStyle(session.selectedCellID?.description.isEmpty == nil ? .white.opacity(0.5) : .white)
            }
        }
        .padding()
        .onAppear {
            loadData()
        }
        .sheet(isPresented: $isAddingModalPresented,
               onDismiss: { loadData() },
               content: { EditingStayingInTeamView(cancelAction: cancel) })
        .sheet(isPresented: $isEditingModalPresented,
               onDismiss: { loadData() },
               content: { EditingStayingInTeamView(title: "Изменение", titleButton: "Изменить", stayingInTeamID: session.selectedCellID, cancelAction: cancel) })
        .sheet(isPresented: $isDeletingModalPresented,
               onDismiss: { loadData() },
               content: { DeletingView(cancelAction: cancel, deleteAction: deleteStayingInTeam, loadData: loadSelectedStayingInTeam )})
    }
    
    private func loadData() {
        do {
            stayingInTeams = try Service.shared.fetchAllStayingInTeams()
        } catch { }
    }
    
    private func cancel() {
        isAddingModalPresented = false
        isEditingModalPresented = false
        isDeletingModalPresented = false
    }
    
    private func loadSelectedStayingInTeam() -> String {
        do {
            selectedStayingInTeam = try Service.shared.fetchStayingInTeam(with: session.selectedCellID!)
        } catch { }
        
        return "Пребывание в команде '\(selectedStayingInTeam.team.name)' студента '\(selectedStayingInTeam.student.fullName)'?"
    }
    
    private func deleteStayingInTeam() {
        do {
            try Service.shared.deleteStayingInTeam(with: session.selectedCellID!)
        } catch { print(error) }
        cancel()
    }
}

