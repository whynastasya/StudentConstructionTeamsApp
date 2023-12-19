//
//  TasksTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct TasksTable: View {
    @State private var selectedTask: Task.ID? = nil
    
    var body: some View {
        Table(tasks, selection: $selectedTask) {
            TableColumn("Тип работы", value: \Task.taskType.name)
            
            TableColumn("Количество часов") { task in
                Text("\(task.countHours)")
            }
            
            TableColumn("Оплата в час") { task in
                Text("\(task.taskType.ratePerHour) руб.")
            }
            
            TableColumn("Команда") { task in
                Text(task.team?.name ?? "")
            }
            
            TableColumn("Статус") { task in
                Text(task.status.rawValue)
                    .foregroundStyle(task.status == .free ? .green : task.status == .completed ? .red : .white)
            }
        }
    }
}

#Preview {
    TasksTable()
}
