//
//  TaskStatusesAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 29.01.2024.
//

import SwiftUI

struct TaskStatusesAdminTable: View {
    @StateObject var session: Session
    var taskStatuses: [TaskStatus]
    
    var body: some View {
        Table(taskStatuses, selection: $session.selectedCellID) {
            TableColumn("Название", value: \.name)
        }
    }
}
