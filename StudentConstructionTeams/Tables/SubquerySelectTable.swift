//
//  SubqueryFromTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 07.02.2024.
//

import SwiftUI

struct SubquerySelectTable: View {
    @State private var students = [Student]()
    @State private var selectedStudent: Student.ID? = nil
    
    var body: some View {
        Table(students, selection: $selectedStudent) {
            TableColumn("ФИО", value: \.fullName)
            
            TableColumn("Группа") { student in
                if let group = student.group {
                    Text(group.name)
                } else {
                    Text("")
                }
            }
        }
        .onAppear {
            do {
                students = try Service.shared.fetchAllStudents()
            } catch { }
        }
    }
}

