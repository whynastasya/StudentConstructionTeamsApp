//
//  LoginView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 04.01.2024.
//

import SwiftUI

struct LoginView: View {
    @State private var phone = ""
    @State private var password = ""
    @StateObject var session = Session.shared
    @State private var errorResult = false
    @State private var phoneIsNumber = true
    
    var body: some View {
        VStack {
            Text("Студенческие строительные отряды")
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.accent)
            
            HStack {
                Image("login")
                    .resizable()
                    .frame(width: 250, height: 250)
                VStack {
                    Text("Авторизация")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .fontDesign(.rounded)
                    
                    if errorResult {
                        Text("Неверный логин или пароль. Повторите снова.")
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                            .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.red, lineWidth: 1))
                            .background(.red.opacity(0.1))
                    }
                    
                    TextField("Ваш номер телефона", text: $phone)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
                        .fontDesign(.rounded)
                        .onChange(of: phone, {
                            phoneIsNumber = phone.isNumber
                        })
                    
                    if !phoneIsNumber {
                        Text("Допустимые значения - цифры")
                            .foregroundStyle(.red)
                            .fontDesign(.rounded)
                    }
                    
                    SecureField("Пароль", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                        .fontDesign(.rounded)
                    
                    VStack {
                        AuthorizationButton(action: { login() }, text: "Войти")
                    }
                    .disabled((phone.isEmpty || password.isEmpty))
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    
                    Button(action: {
                        session.currentScreen = .register
                    }, label: {
                        Text("Нет аккаунта? Регистрация")
                            .foregroundStyle(.gray)
                            .fontDesign(.rounded)
                    })
                    .buttonStyle(.link)
                }
                .padding()
                .background()
                .clipShape(.rect(cornerRadius: 20))
            }
            .padding()
        }
        .frame(width: 600, height: 600)
        .animation(.easeInOut, value: errorResult)
        .animation(.easeInOut, value: phoneIsNumber)
    }
    
    private func login() {
        Task {
            do {
                var user = try Service.service.verificateUser(phone: phone, password: password)
                
                guard let user else { return errorResult = true }
                
                switch user {
                    case let .student(student):
                        session.currentScreen = .studentAccount
                        session.user = student
                    case let .teamDirector(teamDirector):
                        session.currentScreen = .teamDirectorAccount
                        session.user = teamDirector
                    case let .admin(user):
                        session.currentScreen = .adminAccount
                        session.user = user
                }
            } catch {
                print(error)
                errorResult = true
            }
        }
    }
}

//#Preview {
//    LoginView()
//}
