//
//  EditingStudentView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 30.01.2024.
//

import SwiftUI

struct EditingStudentView: View {
    @State var title = "Добавление"
    @State var titleButton = "Добавить"
    @State private var student = Student(id: 0, userID: 0, name: "", surname: "", patronymic: "", phone: "", isElder: false, group: Group(id: 0, name: "", faculty: ""), team: Team(id: 0, name: "", countStudents: 0))
    @State var studentID: Int?
    @State private var nameIsRussian = true
    @State private var surnameIsRussian = true
    @State private var patronymicIsRussian = true
    @State private var phoneIsNumber = true
    @State private var teams = [Team]()
    @State private var groups = [Group]()
    @State private var newBirthdate: Date? = nil
    var cancelAction : () -> Void
    @State private var errorResult = false
    @State private var successResultForEditing = false
    @State private var successResultForAdding = false
    @State private var isElder = true
    
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
                Text("Данные студента изменены")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            if successResultForAdding {
                Text("Новый студент добавлен")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            TextField("Фамилия*", text: $student.surname)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: student.surname, {
                    surnameIsRussian = student.surname.isContainsOnlyRussianCharacters
                })
            
            if !surnameIsRussian {
                Text("Допустимые значения - русский алфавит")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            TextField("Имя*", text: $student.name)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: student.name, {
                    nameIsRussian = student.name.isContainsOnlyRussianCharacters
                })
            
            if !nameIsRussian {
                Text("Допустимые значения - русский алфавит")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            TextField("Отчество", text: Binding(get: { student.patronymic ?? "" }, set: { student.patronymic = $0 }))
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: student.patronymic, {
                    if let patronymic = student.patronymic {
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
                DatePicker("", selection: $student.birthdate.toUnwrapped(defaultValue: Date()), in: ...Date(), displayedComponents: .date)
                    .fixedSize()
                    .environment(\.locale, Locale.init(identifier: "ru_RU"))
                    .labelsHidden()
                    .datePickerStyle(.field)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .onChange(of: student.birthdate, perform: { value in
                        newBirthdate = student.birthdate
                    })
            }
            
            TextField("Номер телефона*", text: $student.phone)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: student.phone, {
                    phoneIsNumber = student.phone.isNumber
                })
            
            if !phoneIsNumber {
                Text("Допустимые значения - цифры")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            Picker("Выберите команду", selection: Binding(get: { student.team?.id ?? 0 }, set: { student.team?.id = $0 })) {
                Text("").tag(0)
                ForEach(teams ?? [Team](), id: \.self) { team in
                    Text(team.name).tag(team.id)
                }
            }
            .fontDesign(.rounded)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
            
            Picker("Выберите группу", selection: Binding(get: { student.group?.id ?? 0 }, set: { student.group?.id = $0 })) {
                Text("").tag(0)
                ForEach(groups ?? [Group](), id: \.self) { group in
                    Text(group.name).tag(group.id)
                }
            }
            .fontDesign(.rounded)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
            
            HStack {
                Spacer()
                Toggle(isOn: $student.isElder.animation(), label: {
                    Text("Является старостой?")
                        .fontDesign(.rounded)
                })
                .toggleStyle(.switch)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 15))
                .onChange(of: student.isElder, {
                    let id = student.group?.id
                    var elderID: Int? = nil
                    for group in groups {
                        if group.id == id {
                            elderID = group.elderID
                        }
                    }
                    isElder = !((student.isElder == true) && (elderID != nil))
                })
            }
            
            if !isElder {
                Text("У данной группы уже есть староста")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
                    .padding()
            }
        
            HStack {
                CancelButton(action: cancelAction)
                
                EditButton(action: editGroup, name: titleButton)
                    .disabled(!nameIsRussian || student.name.isEmpty || !surnameIsRussian || student.surname.isEmpty || !patronymicIsRussian || !phoneIsNumber || student.phone.isEmpty || !isElder)
            }
        }
        .padding()
        .onAppear {
            do {
                if let id = studentID {
                    student = try Service.shared.fetchStudent(with: id)!
                }
                teams = try Service.shared.fetchAllTeams()
                groups = try Service.shared.fetchAllGroups()
            } catch { }
        }
        .animation(.easeInOut, value: nameIsRussian)
        .animation(.easeInOut, value: surnameIsRussian)
        .animation(.easeInOut, value: patronymicIsRussian)
        .animation(.easeInOut, value: phoneIsNumber)
        .animation(.easeInOut, value: isElder)
        .animation(.easeInOut, value: errorResult)
        .animation(.easeInOut, value: successResultForAdding)
        .animation(.easeInOut, value: successResultForEditing)
        .frame(minWidth: 400, minHeight: 420)
        .background(.black.opacity(0.2))
    }
    
    private func editGroup() {
        if title == "Добавление" {
            do {
                try Service.shared.addNewStudent(name: student.name, surname: student.surname, patronymic: student.patronymic ?? "", phone: student.phone, birthdate: newBirthdate, teamID: student.team?.id, groupID: student.group?.id, isElder: student.isElder)
                successResultForAdding = true
                errorResult = false
                successResultForAdding = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch {
                errorResult = true
                print(error)
            }
        } else {
            do {
                try Service.shared.updateStudent(with: student.id, userID: student.userID, newName: student.name, newSurname: student.surname, newPatronymic: student.patronymic ?? "", newPhone: student.phone, newBirthdate: newBirthdate, newTeamID: student.team?.id, newGroupID: student.group?.id, isElder: student.isElder)
                errorResult = false
                successResultForEditing = true
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
