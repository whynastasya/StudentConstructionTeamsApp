//
//  MultitabularViewTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 06.02.2024.
//

import SwiftUI

struct MultitabularViewTable: View {
    var teamSummary: [TeamSummary]
    @StateObject var session: Session
    
    var body: some View {
        Table(teamSummary, selection: $session.selectedCellID) {
            
            TableColumn("Название команды", value: \.teamName)
            
            TableColumn("Количество студентов") {
                Text("\($0.studentsCount)")
            }
            
            TableColumn("Средний заработок участника") {
                if let earnings = $0.averageEarnings {
                    Text("\(earnings) руб.")
                } else {
                    Text("0 руб.")
                }
            }
            
            TableColumn("Последняя дата вступления") {
                if let date = $0.latestStayStart {
                    Text(date, style: .date)
                } else {
                    Text("-")
                }
            }
        }
        .clipShape(.rect(cornerRadius: 25))
    }
}
