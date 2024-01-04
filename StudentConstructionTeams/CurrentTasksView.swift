//
//  CurrentTasksView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct CurrentTasksView: View {
    @State var teamTasks = tasks
    
    var body: some View {
        HStack {
            ForEach(tasks) { task in
                VStack {
                    HStack {
                        Text("Тип задачи: ") +
                        Text(task.taskType.name)
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
                        Text(task.status.rawValue)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(minWidth: 200)
                .background()
                .clipShape(.rect(cornerRadius: 15))
            }
        }
    }
}

#Preview {
    CurrentTasksView()
}
