//
//  CompositeMultitableQueryWithCaseExpressionTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 04.02.2024.
//

import SwiftUI

struct CompositeMultitableQueryWithCaseExpressionTable: View {
    @State private var students = [Student]()
    @State private var selectedStudent: Student.ID? = nil
    
    var body: some View {
        Table(students, selection: $selectedStudent) {
            
            TableColumn("ФИО студента", value: \.fullName)
            
            TableColumn("Команда") { student in
                Text(student.group?.name ?? "")
            }
            
            TableColumn("Статус") { student in
                Text(student.isElder ? "Староста" : "Студент")
                    .foregroundStyle(student.isElder ? .green : .white)
            }
        }
        .clipShape(.rect(cornerRadius: 25))
        .onAppear {
            do {
                students = try Service.shared.fetchAllStudents()
            } catch { }
        }
    }
}
