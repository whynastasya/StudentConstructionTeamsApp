//
//  TeamsAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct TeamsAdminTable: View {
    @State private var selectedTeam: Team.ID? = nil
    
    var body: some View {
        Table(teams1, selection: $selectedTeam) {
            TableColumn("Название", value: \.name)
            
            TableColumn("Количество участников") { team in
                Text("\(team.countStudents)")
            }
        }
    }
}

#Preview {
    TeamsAdminTable()
}
