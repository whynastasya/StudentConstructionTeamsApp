//
//  CompletedTasksOnMonthsChart.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 19.12.2023.
//

import SwiftUI
import Charts

struct CompletedTasksOnMonthsChart: View {
    private var completedTasksOnMonths = [CompletedTasksOnMonths]()
    
    var body: some View {
        Chart {
            ForEach(completedTasksOnMonths) {
                BarMark(
                    x: .value("Месяцы", $0.month.rawValue),
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
            Text("Месяцы")
        }
        .chartYAxisLabel(position: .leading) {
            Text("Количество заданий")
        }
        .padding()
        .background()
        .clipShape(.rect(cornerRadius: 25))
    }
}
