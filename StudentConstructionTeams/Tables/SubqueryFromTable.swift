//
//  SubqueryFromTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 07.02.2024.
//

import SwiftUI

struct SubqueryFromTable: View {
    var students: [Student]
    @State private var selectedStudent: Student.ID? = nil
    
    var body: some View {
        Table(students, selection: $selectedStudent) {
            TableColumn("ФИО", value: \.fullName)
            
            TableColumn("День рождения") { student in
                if let birthdate = student.birthdate {
                    Text(birthdate.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))
                } else {
                    Text("")
                }
            }
        }
    }
}
