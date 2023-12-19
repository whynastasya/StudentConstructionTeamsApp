//
//  StayingInTeamAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct StayingInTeamAdminTable: View {
    @State private var selected: Team.ID? = nil
    
    var body: some View {
        Table(stayingInTeam, selection: $selected) {
            TableColumn("Пользователь", value: \.user.fullName)
            
            TableColumn("Команда", value: \.team.name)
            
            TableColumn("Дата вступления в команду") {
                Text($0.startDate, style: .date)
            }
            
            TableColumn("Дата выхода из команды") {
                if let date = $0.endDate {
                    Text(date, style: .date)
                }
            }
        }
    }
}

#Preview {
    StayingInTeamAdminTable()
}
