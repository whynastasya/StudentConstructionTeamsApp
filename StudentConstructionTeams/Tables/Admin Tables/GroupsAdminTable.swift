//
//  GroupsAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct GroupsAdminTable: View {
    @StateObject var session: Session
    var groups: [Group]
    
    var body: some View {
        Table(groups, selection: $session.selectedCellID) {
            TableColumn("Название", value: \.name)
            
            TableColumn("Факультет", value: \.faculty)
        }
    }
}
