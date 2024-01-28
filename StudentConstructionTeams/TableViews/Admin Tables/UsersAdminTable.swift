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
            TableColumn("ФИО", value: \.fullName)
            
            TableColumn("Номер телефона", value: \.phone)
            
            TableColumn("День рождения") { user in
                if let birthdate = user.birthdate {
                    Text(birthdate, style: .date)
                }
            }
            
            TableColumn("Тип пользователя", value: \.userType.name)
        }
    }
}
