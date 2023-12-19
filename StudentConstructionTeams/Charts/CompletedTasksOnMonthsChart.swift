//
//  CompletedTasksOnMonthsChart.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 19.12.2023.
//

import SwiftUI
import Charts

struct CompletedTasksOnMonthsChart: View {
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
                .font(.title3)
        }
        .chartYAxisLabel(position: .leading) {
            Text("Количество заданий")
                .font(.title3)
        }
    }
}

#Preview {
    CompletedTasksOnMonthsChart()
}
