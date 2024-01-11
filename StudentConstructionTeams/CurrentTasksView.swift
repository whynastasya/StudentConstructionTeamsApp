//
//  CurrentTasksView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct CurrentTasksView: View {
    var teamTasks = [ConstructionTask]()
    
    var body: some View {
        HStack {
            ForEach(teamTasks) { task in
                makeCell(from: task)
            }
            .padding()
            .frame(minWidth: 200)
            .background()
            .clipShape(.rect(cornerRadius: 15))
        }
    }
    
    private func makeCell(from task: ConstructionTask) -> some View {
        VStack {
            HStack {
                let name = task.taskType.name
                Text("Тип задачи: ") +
                Text(name)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("Оплата в час: ") +
                Text("\(task.taskType.ratePerHour) руб.")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("Количество часов: ") +
                Text("\(task.countHours)")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("Статус: ") +
                Text(task.status.name)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
