//
//  SwiftUIView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 29.01.2024.
//

import SwiftUI

struct EditingTaskView: View {
    @State var title = "Добавление"
    @State var titleButton = "Добавить"
    @State private var task = ConstructionTask(id: 0, taskType: TaskType(id: 0, name: "", ratePerHour: ""), countHours: "", status: TaskStatus(id: 0, name: ""), team: Team(id: 0, name: "", countStudents: 0))
    @State var taskID: Int?
    @State private var hoursIsNumber = true
    @State private var taskTypes = [TaskType]()
    @State private var taskStatuses = [TaskStatus]()
    @State private var teams = [Team]()
    @State private var newStartDate: Date? = nil
    @State private var newEndDate: Date? = nil
    var cancelAction : () -> Void
    @State private var successResultForEditing = false
    @State private var successResultForAdding = false
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.accent)
            
            if successResultForEditing {
                Text("Данные задачи изменены")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            if successResultForAdding {
                Text("Новая задача добавлена")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            Picker("Тип задачи*", selection: $task.taskType.id) {
                Text("").tag(0)
                ForEach(taskTypes, id: \.self) { taskType in
                    Text(taskType.name).tag(taskType.id)
                }
            }
            .fontDesign(.rounded)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
            
            TextField("Количество часов*", text: $task.countHours)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: task.countHours, {
                    hoursIsNumber = task.countHours.isNumber
                })
            
            if !hoursIsNumber {
                Text("Допустимые значения - цифры")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            Picker("Статус задачи*", selection: $task.status.id) {
                Text("").tag(0)
                ForEach(taskStatuses, id: \.self) { taskStatus in
                    Text(taskStatus.name).tag(taskStatus.id)
                }
            }
            .fontDesign(.rounded)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
            
            Picker("Команды*", selection: Binding(get: { task.team?.id ?? 0 }, set: { task.team?.id = $0 })) {
                Text("").tag(0)
                ForEach(teams, id: \.self) { team in
                    Text(team.name).tag(team.id)
                }
            }
            .fontDesign(.rounded)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
            
            HStack {
                Text("Дата начала")
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 0))
                Spacer()
                DatePicker("", selection: $task.startDate.toUnwrapped(defaultValue: Date()), in: ...Date(), displayedComponents: .date)
                    .fixedSize()
                    .labelsHidden()
                    .datePickerStyle(.field)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .onChange(of: task.startDate, perform: { value in
                        newStartDate = task.startDate
                    })
            }
            
            HStack {
                Text("Дата окончания")
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 0))
                Spacer()
                DatePicker("", selection: $task.endDate.toUnwrapped(defaultValue: Date()), in: ...Date(), displayedComponents: .date)
                    .fixedSize()
                    .labelsHidden()
                    .datePickerStyle(.field)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .onChange(of: task.endDate, perform: { value in
                        newEndDate = task.endDate
                    })
            }
            
            if newStartDate ?? Date() > newEndDate ?? Date() {
                Text("Дата начала раньше даты окончания")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
                    .padding()
            }
            
            HStack {
                CancelButton(action: cancelAction)
                
                EditButton(action: editGroup, name: titleButton)
                    .disabled(!hoursIsNumber || task.countHours.isEmpty || (task.status.id == 0) || (newEndDate ?? Date() < ((newStartDate ?? Calendar.current.date(byAdding: .day, value: -1, to: Date()))!)))
            }
        }
        .padding()
        .onAppear {
            do {
                if let id = taskID {
                    task = try Service.shared.fetchTask(with: id)
                }
                teams = try Service.shared.fetchAllTeams()
                taskStatuses = try Service.shared.fetchAllTaskStatuses()
                taskTypes = try Service.shared.fetchAllTaskTypes()
            } catch { }
        }
        .animation(.easeInOut, value: hoursIsNumber)
        .animation(.easeInOut, value: successResultForAdding)
        .animation(.easeInOut, value: successResultForEditing)
        .animation(.easeInOut, value: newStartDate ?? Date() > newEndDate ?? Date())
        .frame(minWidth: 400, minHeight: 420)
        .background(.black.opacity(0.2))
    }
    
    private func editGroup() {
        if title == "Добавление" {
            do {
                try Service.shared.addNewTask(typeID: task.taskType.id, hours: Int(task.countHours) ?? 0, statusID: task.status.id, teamID: task.team?.id, startDate: newStartDate, endDate: newEndDate)
                successResultForAdding = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch { print(error) }
        } else {
            do {
                try Service.shared.updateTask(with: task.id, typeID: task.taskType.id, hours: Int(task.countHours) ?? 0, statusID: task.status.id, teamID: task.team?.id, startDate: newStartDate, endDate: newEndDate)
                successResultForEditing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch { }
        }
    }
}

