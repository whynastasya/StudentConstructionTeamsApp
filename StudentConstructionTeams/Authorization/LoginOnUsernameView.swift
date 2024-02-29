//
//  LoginOnUsernameView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.02.2024.
//

import SwiftUI

struct LoginOnUsernameView: View {
    @State private var username = ""
    @State private var password = ""
    @StateObject var session: Session
    @State private var errorResult = false
    
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
                    
                    TextField("Имя пользователя", text: $username)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
                        .fontDesign(.rounded)
                    
                    SecureField("Пароль", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                        .fontDesign(.rounded)
                    
                    VStack {
                        AuthorizationButton(action: { login() }, text: "Войти")
                    }
                    .disabled((username.isEmpty || password.isEmpty))
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
    }
    
    private func login() {
        Task {
            do {
                var phone = ""
                switch username {
                    case "team_director_user":
                        phone = "3"
                    case "student_user":
                        phone = "2"
                    case "admin_user":
                        phone = "1"
                    default:
                        errorResult = true
                }
                var user = try Service.shared.verificateUser(phone: phone, password: password)
                print(user)
                guard let user else { return errorResult = true }
                print(user)
                switch user {
                    case let .student(student):
                        session.currentScreen = .studentAccount
                        session.userID = student
                    case let .teamDirector(teamDirector):
                        session.currentScreen = .teamDirectorAccount
                        session.userID = teamDirector
                    case let .admin(user):
                        session.currentScreen = .adminAccount
                        session.userID = user
                }
                print(session.currentScreen, session.userID)
            } catch {
                print(error)
                errorResult = true
            }
        }
    }
}


