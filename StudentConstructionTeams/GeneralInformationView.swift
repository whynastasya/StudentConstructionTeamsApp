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
            if information.name != nil {
                HStack {
                    Text("Название: ") +
                    Text(information.name!)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if information.director != nil {
                HStack {
                    Text("Руководитель: ") +
                    Text(information.director!.name)
                        .fontWeight(.bold)
                    + Text(" , телефон: ") +
                    Text(information.director!.phone)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if information.elder != nil {
                HStack {
                    Text("Староста: ") +
                    Text(information.elder!.name)
                        .fontWeight(.bold)
                    + Text(" , телефон: ") +
                    Text(information.elder!.phone)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if information.taskType != nil {
                HStack {
                    Text("Тип задачи: ") +
                    Text(information.taskType!)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if information.date != nil {
                HStack {
                    Text("Дата: ") +
                    Text(information.date!, style: .date)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if information.countStudent != nil {
                HStack {
                    Text("Количество студентов: ") + Text("\(information.countStudent!)")
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
    GeneralInformationView(information: GeneralInformation(name: "Котята", elder: GeneralInformation.Person(name: "Григорчук Настасья", phone: "89260819584"), director: GeneralInformation.Person(name: "Директор Цирка", phone: "12345678"), taskType: "Покраска", date: Date(), countStudent: 23))
}
