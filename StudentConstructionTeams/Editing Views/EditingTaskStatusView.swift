//
//  EditingTaskStatusView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 29.01.2024.
//

import SwiftUI

struct EditingTaskStatusView: View {
    @State var title = "Добавление"
    @State var titleButton = "Добавить"
    @State private var taskStatus = TaskStatus(id: 0, name: "")
    @State var taskStatusID: Int?
    @State private var nameIsRussian = true
    var cancelAction : () -> Void
    @State private var errorResult = false
    @State private var successResultForEditing = false
    @State private var successResultForAdding = false
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.accent)
            
            if errorResult {
                Text("Такое название статуса уже используется")
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.red, lineWidth: 1))
                    .background(.red.opacity(0.1))
            }
            
            if successResultForEditing {
                Text("Статус задачи изменен")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            if successResultForAdding {
                Text("Статус задачи добавлен")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            TextField("Название*", text: $taskStatus.name)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: taskStatus.name, {
                    nameIsRussian = taskStatus.name.isContainsOnlyRussianCharacters
                })
            
            if !nameIsRussian {
                Text("Допустимые значения - русский алфавит")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            HStack {
                CancelButton(action: cancelAction)
                
                EditButton(action: editGroup, name: titleButton)
                    .disabled(!nameIsRussian || taskStatus.name.isEmpty)
            }
        }
        .padding()
        .onAppear {
            do {
                if let id = taskStatusID {
                    taskStatus = try Service.shared.fetchTaskStatus(with: id)
                }
            } catch { }
        }
        .animation(.easeInOut, value: nameIsRussian)
        .animation(.easeInOut, value: successResultForAdding)
        .animation(.easeInOut, value: successResultForEditing)
        .animation(.easeInOut, value: errorResult)
        .frame(minWidth: 320, minHeight: 220)
        .background(.black.opacity(0.2))
    }
    
    private func editGroup() {
        if title == "Добавление" {
            do {
                try Service.shared.addNewTaskStatus(name: taskStatus.name)
                successResultForAdding = true
                errorResult = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch {
                errorResult = true
                print(error)
            }
        } else {
            do {
                try Service.shared.updateTaskStatus(with: taskStatus.id, newName: taskStatus.name)
                successResultForEditing = true
                errorResult = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch {
                errorResult = true
                print(error)
            }
        }
    }
}

