//
//  EditingTaskTypes.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 29.01.2024.
//

import SwiftUI

struct EditingTaskTypes: View {
    @State var title = "Добавление"
    @State var titleButton = "Добавить"
    @State private var taskType = TaskType(id: 0, name: "", ratePerHour: "")
    @State var taskTypeID: Int?
    @State private var nameIsRussian = true
    @State private var ratePerHourIsNumber = true
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
                Text("Такое название задачи уже используется")
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.red, lineWidth: 1))
                    .background(.red.opacity(0.1))
            }
            
            if successResultForEditing {
                Text("Тип задачи изменен")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            if successResultForAdding {
                Text("Тип задачи добавлен")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            TextField("Название*", text: $taskType.name)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: taskType.name, {
                    nameIsRussian = taskType.name.isContainsOnlyRussianCharacters
                })
            
            if !nameIsRussian {
                Text("Допустимые значения - русский алфавит")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
                
                TextField("Оплата в час*", text: $taskType.ratePerHour)
                    .textFieldStyle(.roundedBorder)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .fontDesign(.rounded)
                    .onChange(of: taskType.ratePerHour, {
                        ratePerHourIsNumber = taskType.ratePerHour.isNumber
                    })
            
            if !ratePerHourIsNumber {
                Text("Допустимые значения - цифры")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            HStack {
                CancelButton(action: cancelAction)
                
                EditButton(action: editGroup, name: titleButton)
                    .disabled(!nameIsRussian || taskType.name.isEmpty || !ratePerHourIsNumber || taskType.ratePerHour.isEmpty)
            }
        }
        .padding()
        .onAppear {
            do {
                if let id = taskTypeID {
                    taskType = try Service.shared.fetchTaskType(with: id)
                }
            } catch { }
        }
        .animation(.easeInOut, value: nameIsRussian)
        .animation(.easeInOut, value: ratePerHourIsNumber)
        .animation(.easeInOut, value: successResultForAdding)
        .animation(.easeInOut, value: successResultForEditing)
        .animation(.easeInOut, value: errorResult)
        .frame(minWidth: 320, minHeight: 320)
        .background(.black.opacity(0.2))
    }
    
    private func editGroup() {
        if title == "Добавление" {
            do {
                try Service.shared.addNewTaskType(name: taskType.name, ratePerHour: Int(taskType.ratePerHour) ?? 0)
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
                try Service.shared.updateTaskType(with: taskType.id, newName: taskType.name, ratePerHour: Int(taskType.ratePerHour) ?? 0)
                successResultForEditing = true
                errorResult = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch {
                errorResult = true
            }
        }
    }
}
