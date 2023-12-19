//
//  GeneralInformationView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 15.12.2023.
//

import SwiftUI

struct GeneralInformationView: View {
    var information: GeneralInformation
    var body: some View {
        VStack {
            if let taskType = information.taskType {
                Text("Текущее задание")
                    .font(.title2)
                HStack {
                    Text("Тип задачи: ") +
                    Text(taskType)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let groupName = information.groupName {
                Text("Моя группа")
                    .font(.title2)
                HStack {
                    Text("Название: ") +
                    Text(groupName)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let teamName = information.teamName {
                Text("Моя команда")
                    .font(.title2)
                HStack {
                    Text("Название: ") +
                    Text(teamName)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let director = information.director {
                HStack {
                    Text("Руководитель: ") +
                    Text(director.name)
                        .fontWeight(.bold)
                    + Text(" , телефон: ") +
                    Text(director.phone)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let elder = information.elder {
                HStack {
                    Text("Староста: ") +
                    Text(elder.name)
                        .fontWeight(.bold)
                    + Text(" , телефон: ") +
                    Text(elder.phone)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let date = information.date {
                HStack {
                    Text("Дата: ") +
                    Text(date, style: .date)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let countStudents = information.countStudents {
                HStack {
                    Text("Количество студентов: ") + Text("\(countStudents)")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background()
        .clipShape(.rect(cornerRadius: 30))
    }
}

#Preview {
    GeneralInformationView(information: GeneralInformation(groupName: "BSBO-02-21", teamName: "Cats", elder: GeneralInformation.Person(name: "Григорчук Настасья", phone: "89260819584"), director: GeneralInformation.Person(name: "Директор Цирка", phone: "12345678"), taskType: "Покраска", date: Date(), countStudents: 23))
}
