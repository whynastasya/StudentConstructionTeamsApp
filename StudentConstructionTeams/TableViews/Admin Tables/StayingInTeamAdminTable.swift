//
//  StayingInTeamAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct StayingInTeamAdminTable: View {
    @State private var selected: Team.ID? = nil
    private var stayingInTeam: [StayingInTeam]
    
    var body: some View {
        Table(stayingInTeam, selection: $selected) {
            TableColumn("Пользователь", value: \.user.fullName)
            
            TableColumn("Команда", value: \.team.name)
            
            TableColumn("Дата вступления в команду") {
                Text($0.startDate.formatted(.dateTime.day().month().year().hour().minute().locale(Locale(identifier: "ru_RU"))))
            }
            
            TableColumn("Дата выхода из команды") {
                if let date = $0.endDate {
                    Text(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))
                }
            }
        }
    }
}
