//
//  TeamDirectorsAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct TeamDirectorsAdminTable: View {
    @State private var selectedTeamDirector: TeamDirector.ID? = nil
    
    var body: some View {
        Table(teamDirectors, selection: $selectedTeamDirector) {
            TableColumn("ФИО", value: \.fullName)
            
            TableColumn("Команда") { teamDirector in
                Text(teamDirector.team?.name ?? "")
            }
            
            TableColumn("Номер телефона", value: \.phone)
            
            TableColumn("День рождения") { teamDirector in
                if let birthdate = teamDirector.birthdate {
                    Text(birthdate, style: .date)
                }
            }
        }
    }
}

#Preview {
    TeamDirectorsAdminTable()
}
