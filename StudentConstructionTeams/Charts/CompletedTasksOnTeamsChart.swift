//
//  CountCompletedTasksOnTeamsChart.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 19.12.2023.
//

import SwiftUI
import Charts

struct CompletedTasksOnTeamsChart: View {
    var completedTasksOnTeams = [CompletedTasksOnTeams]()
    
    var body: some View {
        Chart {
            ForEach(completedTasksOnTeams) {
                BarMark(
                    x: .value("Команды", $0.teamName),
                    y: .value("Количество заданий", $0.count)
                )
                .clipShape(.rect(cornerRadius: 5))
            }
        }
        .padding()
        .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom))
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text("Команды")
        }
        .chartYAxisLabel(position: .leading) {
            Text("Количество заданий")
        }
        .padding()
        .background()
        .clipShape(.rect(cornerRadius: 25))
    }
}
