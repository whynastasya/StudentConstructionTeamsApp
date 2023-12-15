//
//  MyTeamTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.12.2023.
//

import SwiftUI

struct MyTeamTable: View {
    @State private var selectedStudent: Student.ID? = nil
    var body: some View {
        Table(students, selection: $selectedStudent) {
            TableColumn("ФИО", value: \.fullName)
            TableColumn("Группа") { student in
                Text(student.group ?? "")
            }
            TableColumn("Номер телефона", value: \.phone)
            TableColumn("День рождения") { student in
                if student.birthdate != nil {
                    Text(student.birthdate!, style: .date)
                } else {
                    Text("")
                }
            }
        }
    }
}

#Preview {
    MyTeamTable()
}
