//
//  GroupsAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct GroupsAdminTable: View {
    @State private var selectedGroup: Group.ID? = nil
    var groups: [Group]
    
    var body: some View {
        Table(groups, selection: $selectedGroup) {
            TableColumn("Название", value: \.name)
            
            TableColumn("Факультет", value: \.faculty)
        }
    }
}
