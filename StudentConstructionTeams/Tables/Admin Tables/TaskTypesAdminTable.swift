//
//  TaskTypeAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct TaskTypesAdminTable: View {
    @StateObject var session: Session
    var taskTypes: [TaskType]
    
    var body: some View {
        Table(taskTypes, selection: $session.selectedCellID) {
            TableColumn("Тип работы", value: \.name)
            
            TableColumn("Оплата в час") { taskType in
                Text("\(taskType.ratePerHour) руб.")
            }
        }
    }
}
