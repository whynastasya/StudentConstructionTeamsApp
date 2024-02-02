//
//  TeamsAdminView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 01.02.2024.
//

import SwiftUI

struct TeamsAdminView: View {
    @StateObject var session: Session
    @State private var teams = [Team]()
    @State private var isEditingModalPresented = false
    @State private var isAddingModalPresented = false
    @State private var isDeletingModalPresented = false
    @State private var selectedTeam = Team(id: 0, name: "", countStudents: 0)
    
    var body: some View {
        VStack {
            VStack {
                Text("Команды")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                TeamsAdminTable(session: session, teams: teams)
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
               content: { EditingTeamView(cancelAction: cancel) })
        .sheet(isPresented: $isEditingModalPresented,
               onDismiss: { loadData() },
               content: { EditingTeamView(title: "Изменение", titleButton: "Изменить", teamID: session.selectedCellID, cancelAction: cancel) })
        .sheet(isPresented: $isDeletingModalPresented,
               onDismiss: { loadData() },
               content: { DeletingView(cancelAction: cancel, deleteAction: deleteTeam, loadData: loadSelectedTeam )})
    }
    
    private func loadData() {
        do {
            teams = try Service.shared.fetchAllTeams()
        } catch { }
    }
    
    private func cancel() {
        isAddingModalPresented = false
        isEditingModalPresented = false
        isDeletingModalPresented = false
    }
    
    private func loadSelectedTeam() -> String {
        do {
            selectedTeam = try Service.shared.fetchTeam(with: session.selectedCellID!)
        } catch { }
        
        return "Группу '\(selectedTeam.name)'?"
    }
    
    private func deleteTeam() {
        do {
            try Service.shared.deleteTeam(with: session.selectedCellID!)
        } catch { print(error) }
        cancel()
    }
}
