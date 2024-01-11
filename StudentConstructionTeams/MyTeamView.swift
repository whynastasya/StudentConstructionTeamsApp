//
//  MyTeamView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 19.12.2023.
//

import SwiftUI

struct MyTeamView: View {
    @State var teamInformation = GeneralInformation(teamName: "Котята", director: GeneralInformation.Person(name: "Федор Иванов", phone: "12341234"), countStudents: 24)
    @State var currentTaskInformation = GeneralInformation(taskType: TaskType(id: 1, name: "govno", ratePerHour: 200), startDate: Date())
    @State var students = [Student]()
    
    var body: some View {
        VStack {
            GeneralInformationView(information: teamInformation)
            GeneralInformationView(information: currentTaskInformation)
            MyTeamTable(students: students)
        }
        .padding()
    }
}

#Preview {
    MyTeamView()
}
