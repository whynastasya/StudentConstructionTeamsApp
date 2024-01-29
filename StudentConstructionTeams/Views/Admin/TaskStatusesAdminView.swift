//
//  TaskStatusAdminView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 29.01.2024.
//

import SwiftUI

struct TaskStatusesAdminView: View {
    @StateObject var session: Session
    @State private var taskStatuses = [TaskStatus]()
    @State private var isEditingModalPresented = false
    @State private var isAddingModalPresented = false
    @State private var isDeletingModalPresented = false
    @State private var selectedTaskStatus = TaskStatus(id: 0, name: "")
    
    var body: some View {
        VStack {
            VStack {
                Text("Статусы выполнения заданий")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                TaskStatusesAdminTable(session: session, taskStatuses: taskStatuses)
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
               content: { EditingTaskStatusView(cancelAction: cancel)})
        .sheet(isPresented: $isEditingModalPresented,
               onDismiss: { loadData() },
               content: { EditingTaskStatusView(title: "Изменение", titleButton: "Изменить", taskStatusID: session.selectedCellID, cancelAction: cancel) })
        .sheet(isPresented: $isDeletingModalPresented,
               onDismiss: { loadData() },
               content: { DeletingView(cancelAction: cancel, deleteAction: deleteGroup, loadData: loadSelectedGroup )})
    }
    
    private func loadData() {
        do {
            taskStatuses = try Service.shared.fetchAllTaskStatuses()
        } catch { }
    }
    
    private func cancel() {
        isAddingModalPresented = false
        isEditingModalPresented = false
        isDeletingModalPresented = false
    }
    
    private func loadSelectedGroup() -> String {
        do {
            selectedTaskStatus = try Service.shared.fetchTaskStatus(with: session.selectedCellID!)
        } catch { }
        
        return "Статус задачи '\(selectedTaskStatus.name)'?"
    }
    
    private func deleteGroup() {
        do {
            try Service.shared.deleteTaskStatus(with: session.selectedCellID!)
        } catch { }
        cancel()
    }
}
