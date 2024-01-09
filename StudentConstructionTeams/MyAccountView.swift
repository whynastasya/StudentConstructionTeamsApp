//
//  MyAccountView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct MyAccountView: View {
    @State var user: any UserProtocol
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding()
                VStack {
                    Text(user.surname)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(user.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(user.patronymic ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background()
            .clipShape(.rect(cornerRadius: 15))
            
            Text("День рождения")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
                .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 0))
            
            VStack {
                if let birthdate = user.birthdate {
                    Text(birthdate, style: .date)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("-")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 12))
            
            Text("Номер телефона")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
                .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 0))
            
            VStack {
                Text(user.phone)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 12))
            Spacer()
            ExitButton()
        }
        .padding()
    }
}
