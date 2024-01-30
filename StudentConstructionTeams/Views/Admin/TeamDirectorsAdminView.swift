//
//  TeamDirectorsAdminView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 30.01.2024.
//

import SwiftUI

struct TeamDirectorsAdminView: View {
    @StateObject var session: Session
    @State private var teamDirectors = [TeamDirector]()
    @State private var isEditingModalPresented = false
    @State private var isAddingModalPresented = false
    @State private var isDeletingModalPresented = false
    @State private var selectedTeamDirector = TeamDirector(id: 0, userID: 0, name: "", surname: "", phone: "")
    
    var body: some View {
        VStack {
            VStack {
                Text("Руководители команд")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                TeamDirectorsAdminTable(session: session, teamDirectors: teamDirectors)
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
               content: { EditingTeamDirectorView(cancelAction: cancel) })
        .sheet(isPresented: $isEditingModalPresented,
               onDismiss: { loadData() },
               content: { EditingTeamDirectorView(title: "Изменение", titleButton: "Изменить", teamDirectorID: session.selectedCellID, cancelAction: cancel) })
        .sheet(isPresented: $isDeletingModalPresented,
               onDismiss: { loadData() },
               content: { DeletingView(cancelAction: cancel, deleteAction: deleteGroup, loadData: loadSelectedGroup )})
    }
    
    private func loadData() {
        do {
            teamDirectors = try Service.shared.fetchAllTeamDirectors()
        } catch { }
    }
    
    private func cancel() {
        isAddingModalPresented = false
        isEditingModalPresented = false
        isDeletingModalPresented = false
    }
    
    private func loadSelectedGroup() -> String {
        do {
            selectedTeamDirector = try Service.shared.fetchTeamDirector(with: session.selectedCellID!)!
        } catch { }
        
        return "Руководителя '\(selectedTeamDirector.fullName)'?"
    }
    
    private func deleteGroup() {
        do {
            try Service.shared.deleteTeamDirector(with: session.selectedCellID!)
        } catch { }
        cancel()
    }
}

