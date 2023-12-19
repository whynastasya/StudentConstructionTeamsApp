//
//  EarningsOnMonthsChart.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 19.12.2023.
//

import SwiftUI
import Charts

struct EarningsOnMonthsChart: View {
    var body: some View {
        Chart {
            ForEach(earningsOnMonths) {
                BarMark(
                    x: .value("Месяцы", $0.month.rawValue),
                    y: .value("Заработок", $0.earnings)
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
            Text("Заработок (руб.)")
                .font(.title3)
        }
//        .chartYScale(domain: [0, 1000])
    }
}

#Preview {
    EarningsOnMonthsChart()
}
