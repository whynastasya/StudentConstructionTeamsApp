//
//  TeamDirectorsAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct TeamDirectorsAdminTable: View {
    @StateObject var session: Session
    var teamDirectors: [TeamDirector]
    
    var body: some View {
        Table(teamDirectors, selection: $session.selectedCellID) {
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
