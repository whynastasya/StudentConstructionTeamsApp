//
//  TasksAdminView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 29.01.2024.
//

import SwiftUI

struct TasksAdminView: View {
    @StateObject var session: Session
    @State private var tasks = [ConstructionTask]()
    @State private var isEditingModalPresented = false
    @State private var isAddingModalPresented = false
    @State private var isDeletingModalPresented = false
    @State private var selectedTask = ConstructionTask(id: 0, taskType: TaskType(id: 0, name: "", ratePerHour: ""), countHours: "", status: TaskStatus(id: 0, name: ""))
    
    var body: some View {
        VStack {
            VStack {
                Text("Задачи")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                TasksAdminTable(session: session, tasks: tasks)
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
               content: { EditingTaskView(cancelAction: cancel) })
        .sheet(isPresented: $isEditingModalPresented,
               onDismiss: { loadData() },
               content: { EditingTaskView(title: "Изменение", titleButton: "Изменить", taskID: session.selectedCellID, cancelAction: cancel) })
        .sheet(isPresented: $isDeletingModalPresented,
               onDismiss: { loadData() },
               content: { DeletingView(cancelAction: cancel, deleteAction: deleteTask, loadData: loadSelectedTask )})
    }
    
    private func loadData() {
        do {
            tasks = try Service.shared.fetchAllTasks()
        } catch { }
    }
    
    private func cancel() {
        isAddingModalPresented = false
        isEditingModalPresented = false
        isDeletingModalPresented = false
    }
    
    private func loadSelectedTask() -> String {
        do {
            selectedTask = try Service.shared.fetchTask(with: session.selectedCellID!)
        } catch { }
        
        return "Задание '\(selectedTask.taskType.name), \(selectedTask.countHours) часов'?"
    }
    
    private func deleteTask() {
        do {
            try Service.shared.deleteTask(with: session.selectedCellID!)
        } catch { }
        cancel()
    }
}

