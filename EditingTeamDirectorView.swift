//
//  EditingTeamDirector.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 30.01.2024.
//

import SwiftUI

struct EditingTeamDirectorView: View {
    @State var title = "Добавление"
    @State var titleButton = "Добавить"
    @State private var teamDirector = TeamDirector(id: 0, userID: 0, name: "", surname: "", phone: "", team: Team(id: 0, name: "", countStudents: 0))
    @State var teamDirectorID: Int?
    @State private var nameIsRussian = true
    @State private var surnameIsRussian = true
    @State private var patronymicIsRussian = true
    @State private var phoneIsNumber = true
    @State private var teams = [Team]()
    @State private var newBirthdate: Date? = nil
    var cancelAction : () -> Void
    @State private var errorResult = false
    @State private var successResultForEditing = false
    @State private var successResultForAdding = false
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.accent)
            
            if errorResult {
                Text("Пользователь с таким номером уже зарегистрирован.")
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.red, lineWidth: 1))
                    .background(.red.opacity(0.1))
            }
            
            if successResultForEditing {
                Text("Данные руководителя изменены")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            if successResultForAdding {
                Text("Новый руководитель добавлен")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            TextField("Фамилия*", text: $teamDirector.surname)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: teamDirector.surname, {
                    surnameIsRussian = teamDirector.surname.isContainsOnlyRussianCharacters
                })
            
            if !surnameIsRussian {
                Text("Допустимые значения - русский алфавит")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            TextField("Имя*", text: $teamDirector.name)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: teamDirector.name, {
                    nameIsRussian = teamDirector.name.isContainsOnlyRussianCharacters
                })
            
            if !nameIsRussian {
                Text("Допустимые значения - русский алфавит")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            TextField("Отчество", text: Binding(get: { teamDirector.patronymic ?? "" }, set: { teamDirector.patronymic = $0 }))
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: teamDirector.patronymic, {
                    if let patronymic = teamDirector.patronymic {
                        patronymicIsRussian = patronymic.isContainsOnlyRussianCharacters
                    }
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
                DatePicker("", selection: $teamDirector.birthdate.toUnwrapped(defaultValue: Date()), in: ...Date(), displayedComponents: .date)
                    .fixedSize()
                    .labelsHidden()
                    .datePickerStyle(.field)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .onChange(of: teamDirector.birthdate, perform: { value in
                        newBirthdate = teamDirector.birthdate
                    })
            }
            
            TextField("Номер телефона*", text: $teamDirector.phone)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: teamDirector.phone, {
                    phoneIsNumber = teamDirector.phone.isNumber
                })
            
            if !phoneIsNumber {
                Text("Допустимые значения - цифры")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            Picker("Выберите команду", selection: Binding(get: { teamDirector.team?.id ?? 0 }, set: { teamDirector.team?.id = $0 })) {
                Text("").tag(0)
                ForEach(teams ?? [Team](), id: \.self) { team in
                    Text(team.name).tag(team.id)
                }
            }
            .fontDesign(.rounded)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
        
            HStack {
                CancelButton(action: cancelAction)
                
                EditButton(action: editGroup, name: titleButton)
                    .disabled(!nameIsRussian || teamDirector.name.isEmpty || !surnameIsRussian || teamDirector.surname.isEmpty || !patronymicIsRussian || !phoneIsNumber || teamDirector.phone.isEmpty)
            }
        }
        .padding()
        .onAppear {
            do {
                if let id = teamDirectorID {
                    teamDirector = try Service.shared.fetchTeamDirector(with: id)!
                    teams = try Service.shared.fetchFreeTeamsForTeamDirector(with: id)
                } else {
                    teams = try Service.shared.fetchAllTeams()
                }
                
            } catch { }
        }
        .animation(.easeInOut, value: nameIsRussian)
        .animation(.easeInOut, value: surnameIsRussian)
        .animation(.easeInOut, value: patronymicIsRussian)
        .animation(.easeInOut, value: phoneIsNumber)
        .animation(.easeInOut, value: errorResult)
        .animation(.easeInOut, value: successResultForAdding)
        .animation(.easeInOut, value: successResultForEditing)
        .frame(minWidth: 400, minHeight: 420)
        .background(.black.opacity(0.2))
    }
    
    private func editGroup() {
        if title == "Добавление" {
            do {
                try Service.shared.addNewTeamDirector(name: teamDirector.name, surname: teamDirector.surname, patronymic: teamDirector.patronymic ?? "", phone: teamDirector.phone, birthdate: teamDirector.birthdate, teamID: teamDirector.team?.id)
                successResultForAdding = true
                errorResult = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch {
                errorResult = true
            }
        } else {
            do {
                try Service.shared.updateTeamDirector(with: teamDirector.id, userID: teamDirector.userID, newName: teamDirector.name, newSurname: teamDirector.surname, newPatronymic: teamDirector.patronymic ?? "", newPhone: teamDirector.phone, newBirthdate: teamDirector.birthdate, newTeamID: teamDirector.team?.id)
                successResultForEditing = true
                errorResult = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch { 
                print(error)
                errorResult = true
            }
        }
    }
}

