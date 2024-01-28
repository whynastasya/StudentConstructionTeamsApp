//
//  UserTypeAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 28.01.2024.
//

import SwiftUI

struct UserTypesAdminTable: View {
    @StateObject var session: Session
    var userTypes: [UserType]
    
    var body: some View {
        Table(userTypes, selection: $session.selectedCellID) {
            TableColumn("Тип пользователя", value: \.name)
        }
    }
}
