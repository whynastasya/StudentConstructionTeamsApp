//
//  EarningsOnTeamsChart.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import Charts
import SwiftUI


struct EarningsOnTeamsChart: View {
    
    var body: some View {
        Chart {
            ForEach(earningsOnTeams) {
                BarMark(
                    x: .value("Команды", $0.teamName),
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
            Text("Команды")
                .font(.title3)
        }
        .chartYAxisLabel(position: .leading) {
            Text("Заработок (руб.)")
                .font(.title3)
        }
//        .chartYScale(domain: [0, 6000])
    }
}

#Preview {
    EarningsOnTeamsChart()
}
