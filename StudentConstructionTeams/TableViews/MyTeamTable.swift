//
//  MyTeamTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.12.2023.
//

import SwiftUI

struct MyTeamTable: View {
    @State private var selectedStudent: Student.ID? = nil
    var students: [Student]
    
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
            
            TableColumn("Номер телефона", value: \.phone)
            
            TableColumn("День рождения") { student in
                if let birthdate = student.birthdate {
                    Text(makeDateOnRussian(date: birthdate))
                } 
            }
        }
        .clipShape(.rect(cornerRadius: 20))
    }
    
    private func makeDateOnRussian(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM YYYY"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
}
