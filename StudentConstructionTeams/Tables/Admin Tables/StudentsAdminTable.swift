//
//  StudentsAdminTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 17.12.2023.
//

import SwiftUI

struct StudentsAdminTable: View {
    @StateObject var session: Session
    var students: [Student]
    
    var body: some View {
        Table(students, selection: $session.selectedCellID) {
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
                    Text(birthdate.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))
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
