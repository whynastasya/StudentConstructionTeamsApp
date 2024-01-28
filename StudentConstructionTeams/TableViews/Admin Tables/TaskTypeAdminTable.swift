//
//  TaskTypeAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct TaskTypeAdminTable: View {
    @State private var selectedTaskType: TaskType.ID? = nil
    var taskTypes: [TaskType]
    
    var body: some View {
        Table(taskTypes, selection: $selectedTaskType) {
            TableColumn("Тип работы", value: \.name)
            
            TableColumn("Оплата в час") { taskType in
                Text("\(taskType.ratePerHour) руб.")
            }
        }
    }
}
