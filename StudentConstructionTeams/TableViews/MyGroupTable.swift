//
//  MyGroupTable.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.12.2023.
//

import SwiftUI

struct MyGroupTable: View {
    @State private var selectedStudent: Student.ID? = nil
    
    var body: some View {
        Table(students, selection: $selectedStudent) {
            TableColumn("ФИО", value: \.fullName)
            
            TableColumn("Команда") { student in
                Text(student.team?.name ?? "")
            }
            
            TableColumn("Номер телефона", value: \.phone)
            
            TableColumn("День рождения") { student in
                if let birthdate = student.birthdate {
                    Text(birthdate, style: .date)
                } 
            }
        }
    }
}

#Preview {
    MyGroupTable()
}
