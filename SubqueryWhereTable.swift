//
//  SubqueryWhereTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 07.02.2024.
//

import SwiftUI

struct SubqueryWhereTable: View {
    @State private var tasks = [ConstructionTask]()
    @State private var selectedTask: ConstructionTask.ID? = nil
    
    var body: some View {
        VStack {
            if tasks.count > 0  {
                Text("Среднее количество отработанных часов по всем задачам - \(tasks[0].taskType.ratePerHour)")
                    .bold()
            } else {
                Text("Среднее количество отработанных часов по всем задачам - 0")
                    .bold()
            }
            
            Table(tasks, selection: $selectedTask) {
                
                TableColumn("Тип задачи", value: \.taskType.name)
                
                TableColumn("Часы", value: \.countHours)
            }
            .clipShape(.rect(cornerRadius: 25))
            .onAppear {
                do {
                    tasks = try Service.shared.fetchLargeTasks()
                } catch { }
            }
        }
    }
}
