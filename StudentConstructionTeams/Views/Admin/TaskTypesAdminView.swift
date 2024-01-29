//
//  TaskTypeAdminView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 29.01.2024.
//

import SwiftUI

struct TaskTypesAdminView: View {
    @StateObject var session: Session
    @State private var taskTypes = [TaskType]()
    @State private var isEditingModalPresented = false
    @State private var isAddingModalPresented = false
    @State private var isDeletingModalPresented = false
    @State private var selectedTaskType = TaskType(id: 0, name: "", ratePerHour: "")
    
    var body: some View {
        VStack {
            VStack {
                Text("Типы заданий")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                TaskTypesAdminTable(session: session, taskTypes: taskTypes)
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
               content: { EditingTaskTypesView(cancelAction: cancel)})
        .sheet(isPresented: $isEditingModalPresented,
               onDismiss: { loadData() },
               content: { EditingTaskTypesView(title: "Изменение", titleButton: "Изменить", taskTypeID: session.selectedCellID, cancelAction: cancel) })
        .sheet(isPresented: $isDeletingModalPresented,
               onDismiss: { loadData() },
               content: { DeletingView(cancelAction: cancel, deleteAction: deleteGroup, loadData: loadSelectedGroup )})
    }
    
    private func loadData() {
        do {
            taskTypes = try Service.shared.fetchAllTaskTypes()
        } catch { }
    }
    
    private func cancel() {
        isAddingModalPresented = false
        isEditingModalPresented = false
        isDeletingModalPresented = false
    }
    
    private func loadSelectedGroup() -> String {
        do {
            selectedTaskType = try Service.shared.fetchTaskType(with: session.selectedCellID!)
        } catch { }
        
        return "Тип задачи '\(selectedTaskType.name)'?"
    }
    
    private func deleteGroup() {
        do {
            try Service.shared.deleteTaskType(with: session.selectedCellID!)
        } catch { print(error)}
        cancel()
    }
}
