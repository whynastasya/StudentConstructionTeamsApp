//
//  CorrelatedSubqueryFromTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.02.2024.
//

import SwiftUI

struct CorrelatedSubqueryFromTable: View {
    @State private var teams = [Team]()
    @State private var selectedTeam: Team.ID? = nil
    
    var body: some View {
        Table(teams, selection: $selectedTeam) {
            TableColumn("Название команды", value: \.name)
            
            TableColumn("Общий заработок в команде") {
                Text("\($0.countStudents)")
            }
        }
        .onAppear {
            do {
                teams = try Service.shared.fetchCorrelatedSubqueryForTeams()
            } catch { }
        }
    }
}
