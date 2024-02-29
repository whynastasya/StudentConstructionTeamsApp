//
//  TasksView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct TasksView: View {
    @StateObject var session: Session
    @State private var allTasks = [ConstructionTask]()
    @State private var teamTasks = [ConstructionTask]()
    @State private var errorResultWithAddingTask = false
    @State private var errorResultWithCancelingTask = false
    @State private var teamDirector: TeamDirector? = nil
    
    var body: some View {
        VStack {
            Text("Задания")
                .font(.title2)
            CurrentTasksView(teamTasks: teamTasks)
            
            if errorResultWithAddingTask {
                Text("Задание занято. Выберите свободное.")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.red, lineWidth: 1))
                    .background(.red.opacity(0.1))
            }
            
            if errorResultWithCancelingTask {
                Text("Задание не принадлежит вашей команде.")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.red, lineWidth: 1))
                    .background(.red.opacity(0.1))
            }
            
            TasksTable(session: session, tasks: allTasks)
                .frame(minWidth: 300, minHeight: 200)
            
            if teamDirector?.team != nil {
                HStack {
                    Spacer()
                    
                    EditButton(action: addTask, name: "Взять задание в работу")
                        .disabled(((session.selectedCellID?.description.isEmpty) == nil))
                        .foregroundStyle(session.selectedCellID?.description.isEmpty == nil ? .white.opacity(0.5) : .white)
                    DeleteButton(action: deleteTask, name: "Отказаться от задания")
                        .disabled(((session.selectedCellID?.description.isEmpty) == nil))
                        .foregroundStyle(session.selectedCellID?.description.isEmpty == nil ? .white.opacity(0.5) : .white)
                }
            }
        }
        .padding()
        .animation(.easeInOut, value: errorResultWithAddingTask)
        .animation(.easeInOut, value: errorResultWithCancelingTask)
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        do {
            allTasks = try Service.shared.fetchFreeTasks()
            teamTasks = try Service.shared.fetchTeamTasks(with: session.userID)
            teamDirector = try Service.shared.fetchTeamDirector(userID: session.userID)!
        } catch { }
    }
    
    private func deleteTask() {
        do {
            for task in allTasks {
                if task.id == session.selectedCellID && task.team?.name != teamDirector?.team?.name {
                    errorResultWithCancelingTask = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        errorResultWithCancelingTask = false
                    })
                } else {
                    try Service.shared.cancelTask(with: session.selectedCellID!)
                    loadData()
                }
            }
        } catch { print(error)}
    }
    
    private func addTask() {
        do {
            for task in allTasks {
                if task.id == session.selectedCellID && task.status.name == "В работе" {
                    errorResultWithAddingTask = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        errorResultWithAddingTask = false
                    })
                } else {
                    try Service.shared.takeTaskToWork(with: session.selectedCellID!, teamID: teamDirector?.team?.id)
                    loadData()
                }
            }
        } catch { print(error)}
    }
}
