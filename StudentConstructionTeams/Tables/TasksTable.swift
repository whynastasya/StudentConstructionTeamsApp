//
//  TasksTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct TasksTable: View {
    @StateObject var session: Session
    var tasks: [ConstructionTask]
    
    var body: some View {
        Table(tasks, selection: $session.selectedCellID) {
            TableColumn("Тип работы", value: \ConstructionTask.taskType.name)
            
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
                Text(task.status.name)
                    .foregroundStyle(task.status.name == "Свободно" ? .green : .white)
            }
        }
        .clipShape(.rect(cornerRadius: 25))
    }
}
