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
                if let group = student.group {
                    Text(group.name)
                } else {
                    Text("")
                }
            }
            
            TableColumn("Номер телефона", value: \.phone)
            
            TableColumn("День рождения") { student in
                if let birthdate = student.birthdate {
                    Text(birthdate, style: .date)
                } 
            }
        }
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    MyTeamTable()
}
