//
//  CorrelatedSubquerySelectTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 07.02.2024.
//

import SwiftUI

struct CorrelatedSubquerySelectTable: View {
    @State private var tasks = [ConstructionTask]()
    @State private var selectedTask: ConstructionTask.ID? = nil
    
    var body: some View {
        Table(tasks, selection: $selectedTask) {
            TableColumn("Название команды", value: \.team!.name)
            
            TableColumn("Количество часов", value: \.countHours)
            
            TableColumn("Тип задачи", value: \.taskType.name)
            
            TableColumn("среднее время работы в команде", value: \.)
        }
    }
}

