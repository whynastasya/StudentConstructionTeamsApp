//
//  AdminTasks.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct TasksAdminTable: View {
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
            
            TableColumn("Дата начала") { task in
                if let date = task.startDate {
                    Text(date, style: .date)
                }
            }
            
            TableColumn("Дата окончания") { task in
                if let date = task.endDate {
                    Text(date, style: .date)
                }
            }
        }
    }
}

#Preview {
    TasksAdminTable()
}
