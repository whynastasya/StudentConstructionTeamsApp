//
//  RegisterView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 06.01.2024.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var phone = ""
    @State private var phoneIsNumber = true
    @State private var password = ""
    @State private var name = ""
    @State private var nameIsRussian = true
    @State private var surname = ""
    @State private var surnameIsRussian = true
    @State private var patronymic = ""
    @State private var patronymicIsRussian = true
    @State private var birthdate = Date.now
    @State private var newBirthdate: Date? = nil
    @State private var selectedTeam: Team.ID = 0
    @State private var selectedGroup: Group.ID = 0
    @State private var isStudent = false
    @State private var teams: [Team]?
    @State private var groups: [Group]?
    
    @StateObject var session: Session
    @State private var errorResult = false
    @State private var successResult = false
    
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
                    Text("Регистрация")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .fontDesign(.rounded)
                    
                    if errorResult {
                        Text("Пользователь с таким номером уже существует. Авторизуйтесь")
                            .textFieldStyle(.roundedBorder)
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                            .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.red, lineWidth: 1))
                            .background(.red.opacity(0.1))
                    }
                    
                    if successResult {
                        Text("Новый пользователь создан. Авторизуйтесь")
                            .textFieldStyle(.roundedBorder)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                            .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                            .background(.green.opacity(0.1))
                    }
                    
                    TextField("Ваша фамилия*", text: $surname)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                        .fontDesign(.rounded)
                        .onChange(of: surname, {
                            surnameIsRussian = surname.isContainsOnlyRussianCharacters
                        })
                    
                    if !surnameIsRussian {
                        Text("Допустимые значения - русский алфавит")
                            .foregroundStyle(.red)
                            .fontDesign(.rounded)
                    }
                    
                    TextField("Ваше имя*", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                        .fontDesign(.rounded)
                        .onChange(of: name, {
                            nameIsRussian = name.isContainsOnlyRussianCharacters
                        })
                    
                    if !nameIsRussian {
                        Text("Допустимые значения - русский алфавит")
                            .foregroundStyle(.red)
                            .fontDesign(.rounded)
                    }
                    
                    TextField("Ваше отчество", text: $patronymic)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                        .fontDesign(.rounded)
                        .onChange(of: patronymic, {
                            patronymicIsRussian = patronymic.isContainsOnlyRussianCharacters
                        })
                    
                    if !patronymicIsRussian {
                        Text("Допустимые значения - русский алфавит")
                            .foregroundStyle(.red)
                            .fontDesign(.rounded)
                    }
                    
                    HStack {
                        Text("День рождения")
                            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 0))
                        Spacer()
                        DatePicker("", selection: $birthdate, in: ...Date(), displayedComponents: .date)
                            .fixedSize()
                            .labelsHidden()
                            .datePickerStyle(.field)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                            .onChange(of: birthdate, perform: { value in
                                newBirthdate = birthdate
                            })
                    }
                    
                    Picker("Выберите команду", selection: $selectedTeam) {
                        Text("").tag(0)
                        ForEach(teams ?? [Team](), id: \.self) { team in
                            Text(team.name).tag(team.id)
                        }
                    }
                    .fontDesign(.rounded)
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
                    
                    TextField("Ваш номер телефона*", text: $phone)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                        .fontDesign(.rounded)
                    
                    if !phoneIsNumber {
                        Text("Допустимые значения - цифры")
                            .foregroundStyle(.red)
                            .fontDesign(.rounded)
                    }
                    
                    SecureField("Пароль*", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                        .fontDesign(.rounded)
                        .onChange(of: phone, {
                            phoneIsNumber = phone.isNumber
                        })
                    
                    HStack {
                        Spacer()
                        Toggle(isOn: $isStudent.animation(), label: {
                            Text("Я студент")
                                .fontDesign(.rounded)
                        })
                        .toggleStyle(.switch)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 15))
                    }
                    
                    if isStudent {
                        Picker("Выберите группу*", selection: $selectedGroup) {
                            Text("").tag(0)
                            ForEach(groups ?? [Group](), id: \.self) { group in
                                Text(group.name).tag(group.id)
                            }
                        }
                        .fontDesign(.rounded)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    }
                    
                    VStack {
                        AuthorizationButton(action: { register() }, text: "Зарегистрироваться")
                    }
                    .disabled(
                        (phone.isEmpty || password.isEmpty || name.isEmpty || surname.isEmpty || !phoneIsNumber || 
                         !surnameIsRussian || !nameIsRussian || !patronymicIsRussian
                        )
                    )
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    
                    Button(action: {
                        session.currentScreen = .login
                    }, label: {
                        Text("Уже есть аккаунт? Авторизация")
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
        .frame(width: 700, height: 600)
        .animation(.easeInOut, value: errorResult)
        .animation(.easeInOut, value: phoneIsNumber)
        .animation(.easeInOut, value: nameIsRussian)
        .animation(.easeInOut, value: surnameIsRussian)
        .animation(.easeInOut, value: patronymicIsRussian)
        .onAppear {
            do {
                teams = try Service.service.fetchAllTeams()
                groups = try Service.service.fetchAllGroups()
            } catch {
                
            }
        }
    }
    
    private func register() {
        Task {
            do {
                try Service.service.registerNewUser(
                    phone: phone,
                    password: password,
                    surname: surname,
                    name: name,
                    patronymic: patronymic,
                    birthdate: newBirthdate,
                    teamID: selectedTeam,
                    groupID: selectedGroup,
                    isStudent: isStudent
                )
                successResult = true
                errorResult = false
            } catch {
                errorResult = true
            }
        }
    }
}

//#Preview {
//    RegisterView()
//}
