//
//  GroupsAdminView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 28.01.2024.
//

import SwiftUI

struct GroupsAdminView: View {
    @StateObject var session: Session
    @State private var groups = [Group]()
    @State private var isEditingModalPresented = false
    @State private var isAddingModalPresented = false
    @State private var isDeletingModalPresented = false
    @State private var selectedGroup = Group(id: 0, name: "", faculty: "")
    
    var body: some View {
        VStack {
            VStack {
                Text("Студенческие группы")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                GroupsAdminTable(session: session, groups: groups)
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
               content: { AdminEditingGroup(cancelAction: cancel)})
        .sheet(isPresented: $isEditingModalPresented,
               onDismiss: { loadData() },
               content: { AdminEditingGroup(title: "Изменение", titleButton: "Изменить", groupID: session.selectedCellID, cancelAction: cancel) })
        .sheet(isPresented: $isDeletingModalPresented,
               onDismiss: { loadData() },
               content: { DeletingView(cancelAction: cancel, deleteAction: deleteGroup, loadData: loadSelectedGroup )})
    }
    
    private func loadData() {
        do {
            groups = try Service.shared.fetchAllGroups()
        } catch { }
    }
    
    private func cancel() {
        isAddingModalPresented = false
        isEditingModalPresented = false
        isDeletingModalPresented = false
    }
    
    private func loadSelectedGroup() -> String {
        do {
            selectedGroup = try Service.shared.fetchStudentGroup(with: session.selectedCellID!)
        } catch { }
        
        return "Группу '\(selectedGroup.name)'?"
    }
    
    private func deleteGroup() {
        do {
            try Service.shared.deleteGroup(with: session.selectedCellID!)
        } catch { print(error)}
        cancel()
    }
}

