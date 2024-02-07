//
//  CorrelatedSubqueryWhereTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.02.2024.
//

import SwiftUI

struct CorrelatedSubqueryWhereTable: View {
    @State private var students = [Student]()
    @State private var selectedStudent: Student.ID? = nil
    
    var body: some View {
        Table(students, selection: $selectedStudent) {
            TableColumn("ФИО студента", value: \.fullName)
            TableColumn("Команда", value: \.name)
        }
        .onAppear {
            do {
                students = try Service.shared.fetchCorrelatedSubqueryForStudents()
            } catch { }
        }
    }
}
