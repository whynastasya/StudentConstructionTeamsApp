//
//  TeamsAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct TeamsAdminTable: View {
    @StateObject var session: Session
    var teams: [Team]
    
    var body: some View {
        Table(teams, selection: $session.selectedCellID) {
            TableColumn("Название", value: \.name)
            
            TableColumn("Количество участников") { team in
                Text("\(team.countStudents)")
            }
        }
    }
}
