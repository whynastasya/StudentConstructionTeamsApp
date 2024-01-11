//
//  UsersAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct UsersAdminTable: View {
    @State private var selectedUser: User.ID? = nil
    var users: [User]
    
    var body: some View {
        Table(users, selection: $selectedUser) {
            TableColumn("ФИО", value: \.fullName)
            
            TableColumn("Номер телефона", value: \.phone)
            
            TableColumn("День рождения") { user in
                if let birthdate = user.birthdate {
                    Text(birthdate, style: .date)
                }
            }
        }
    }
}
