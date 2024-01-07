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
    @StateObject var currentScreen: Screen
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
                    
                    TextField("Ваш номер телефона", text: $phone)
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
                    .disabled((phone.isEmpty || password.isEmpty))
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    
                    Button(action: {
                        currentScreen.currentScreen = .register
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
                var user = try Service().verificateUser(phone: phone, password: password)
                    
                switch user {
                    case is Student:
                            currentScreen.currentScreen = .studentAccount
                    case is TeamDirector:
                            currentScreen.currentScreen = .teamDirectorAccount
                    case is User:
                            currentScreen.currentScreen = .adminAccount
                    default:
                        errorResult = true
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
