//
//  StayingInTeamAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct StayingInTeamAdminTable: View {
    @StateObject var session: Session
    var stayingInTeam: [StayingInTeam]
    
    var body: some View {
        Table(stayingInTeam, selection: $session.selectedCellID) {
            TableColumn("Пользователь", value: \.student.fullName)
            
            TableColumn("Команда", value: \.team.name)
            
            TableColumn("Дата вступления в команду") {
                Text($0.startDate.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))
            }
            
            TableColumn("Дата выхода из команды") {
                if let date = $0.endDate {
                    Text(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))
                }
            }
        }
    }
}
