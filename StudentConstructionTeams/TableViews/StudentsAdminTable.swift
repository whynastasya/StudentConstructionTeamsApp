//
//  StudentsAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct StudentsAdminTable: View {
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
            
            TableColumn("Команда") { student in
                Text(student.team?.name ?? "")
            }
            
            TableColumn("Номер телефона", value: \.phone)
            
            TableColumn("День рождения") { student in
                if let birthdate = student.birthdate {
                    Text(birthdate, style: .date)
                }
            }
            
            TableColumn("Заработок за все время") { student in
                Text("\(student.earnings) руб.")
            }
            
            TableColumn("Является ли старостой?") { student in
                Text(student.isElder ? "Да" : "Нет")
                    .foregroundStyle(student.isElder ? .green : .white)
            }
        }
    }
}

#Preview {
    StudentsAdminTable()
}
