//
//  TasksView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct TasksView: View {
    
    @State var allTasks = [ConstructionTask]()
    var body: some View {
        VStack {
            Text("Задания")
                .font(.title2)
            CurrentTasksView()
            
            HStack {
                VStack {
                    Text("Выполненные задачи в этом месяце по командам")
                        .font(.title3)
                        .foregroundStyle(.gray)
                    CompletedTasksOnTeamsChart()
                }
                .padding()
                
                VStack {
                    Text("Выполненные задачи в этом году")
                        .font(.title3)
                        .foregroundStyle(.gray)
                    CompletedTasksOnMonthsChart()
                }
                .padding()
            }
            .frame(minHeight: 300)
            
            TasksTable(tasks: allTasks)
                .frame(minWidth: 300, minHeight: 200)
        }
        .padding()
    }
}
