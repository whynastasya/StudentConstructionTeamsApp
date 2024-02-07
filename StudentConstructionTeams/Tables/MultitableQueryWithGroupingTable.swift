//
//  MultitableQueryWithGroupingTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.02.2024.
//

import SwiftUI

struct MultitableQueryWithGroupingTable: View {
    @State private var selectedTeam: Team.ID? = nil
    var teams: [Team]
    
    var body: some View {
        Table(teams, selection: $selectedTeam) {
            TableColumn("Команда", value: \.name)
            
            TableColumn("Количество студентов") {
                Text("\($0.countStudents)")
            }
            
            TableColumn("Средний заработок") {
                Text("\($0.id) рублей")
            }
        }
    }
}
