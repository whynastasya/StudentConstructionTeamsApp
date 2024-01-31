//
//  UsersAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct UsersAdminTable: View {
    @StateObject var session: Session
    var users: [User]    
    
    var body: some View {
        Table(users, selection: $session.selectedCellID) {
            TableColumn("ID") { user in
                Text("\(user.id)")
            }
            TableColumn("ФИО", value: \.fullName)
            
            TableColumn("Номер телефона", value: \.phone)
            
            TableColumn("День рождения") { user in
                if let birthdate = user.birthdate {
                    Text(birthdate.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))
                }
            }
            
            TableColumn("Тип пользователя", value: \.userType.name)
        }
    }
}
