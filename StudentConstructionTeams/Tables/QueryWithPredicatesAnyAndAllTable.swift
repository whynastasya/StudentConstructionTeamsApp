//
//  QueryWithPredicatesAnyAndAllTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.02.2024.
//

import SwiftUI

struct QueryWithPredicatesAnyAndAllTable: View {
    @State private var groups = [Group]()
    @State private var selectedGroup: Group.ID? = nil
    
    var body: some View {
        Table(groups, selection: $selectedGroup) {
            TableColumn("Название группы", value: \.name)
        }
        .onAppear {
            do {
                groups = try Service.shared.fetchGroupForMultitableQueryWithPredicates()
            } catch { }
        }
    }
}
