//
//  MultitabularView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 05.02.2024.
//

import SwiftUI

struct MultitabularView: View {
    @State private var teamSummary = [TeamSummary]()
    @StateObject var session: Session
    @State private var isEditingModalPresented = false
    @State private var isAddingModalPresented = false
    @State private var isDeletingModalPresented = false
    @State private var selectedTeam = Team(id: 0, name: "", countStudents: 0)
    
    var body: some View {
        VStack {
            VStack {
                Text("Многотабличный view")
                    .font(.title)
                    .bold()
                
                Text("Cводная информация о командах. В представлении указаны название команды, количество студентов в команде, общее количество студентов и средний заработок студентов в каждой команде.")
                
                MultitabularViewTable(teamSummary: teamSummary, session: session)
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
            teamSummary = try Service.shared.fetchTeamSummary()
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
