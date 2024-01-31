//
//  AdminTasks.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct TasksAdminTable: View {
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
                    .foregroundStyle(task.status.name == "Свободно" ? .green : task.status.name == "Выполнено" ? .red : .white)
            }
            
            TableColumn("Дата начала") { task in
                if let date = task.startDate {
                    Text(date.formatted(.dateTime.day().month().year().hour().minute().locale(Locale(identifier: "ru_RU"))))
                }
            }
            
            TableColumn("Дата окончания") { task in
                if let date = task.endDate {
                    Text(date.formatted(.dateTime.day().month().year().hour().minute().locale(Locale(identifier: "ru_RU"))))
                }
            }
        }
    }
}
