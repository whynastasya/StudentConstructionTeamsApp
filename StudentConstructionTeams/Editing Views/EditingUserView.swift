//
//  EditingUserView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 12.01.2024.
//

import SwiftUI

struct EditingUserView: View {
    @State var user: User
    @State var surnameIsRussian = true
    @State var nameIsRussian = true
    @State var patronymicIsRussian = true
    @State var phoneIsNumber = true
    @State private var newBirthdate: Date? = nil
    @State var password = ""
    @State var cancelAction: () -> Void
    @State private var errorResult = false
    @State private var successResult = false
    
    var body: some View {
        VStack {
            Text("Редактирование")
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.accent)
            
            if errorResult {
                Text("Номер уже зарегистрирован. Введите другой номер")
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.red, lineWidth: 1))
                    .background(.red.opacity(0.1))
            }
            
            if successResult {
                Text("Данные пользователя изменены")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            TextField("Фамилия*", text: $user.surname)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: user.surname, {
                    surnameIsRussian = user.surname.isContainsOnlyRussianCharacters
                })
            
            if !surnameIsRussian {
                Text("Допустимые значения - русский алфавит")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            TextField("Имя*", text: $user.name)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: user.name, {
                    nameIsRussian = user.name.isContainsOnlyRussianCharacters
                })
            
            if !nameIsRussian {
                Text("Допустимые значения - русский алфавит")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            TextField("Отчество", text: Binding(get: { user.patronymic ?? "" }, set: { user.patronymic = $0 }))
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: user.patronymic, {
                    if let patronymic = user.patronymic {
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
                DatePicker("", selection: $user.birthdate.toUnwrapped(defaultValue: Date()), in: ...Date(), displayedComponents: .date)
                    .fixedSize()
                    .labelsHidden()
                    .datePickerStyle(.field)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .onChange(of: user.birthdate, perform: { value in
                        newBirthdate = user.birthdate
                    })
            }
            
            TextField("Ваш номер телефона*", text: $user.phone)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: user.phone, {
                    phoneIsNumber = user.phone.isNumber
                })
            
            if !phoneIsNumber {
                Text("Допустимые значения - цифры")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            HStack {
                CancelButton(action: cancelAction)
                EditButton(action: editUser)
                    .disabled(!surnameIsRussian || user.surname.isEmpty || !nameIsRussian || user.name.isEmpty || !patronymicIsRussian || !phoneIsNumber || user.phone.isEmpty)
            }
        }
        .frame(minWidth: 300, minHeight: 350)
        .padding()
        .background(.black.opacity(0.2))
        .animation(.easeInOut, value: errorResult)
        .animation(.easeInOut, value: phoneIsNumber)
        .animation(.easeInOut, value: nameIsRussian)
        .animation(.easeInOut, value: surnameIsRussian)
        .animation(.easeInOut, value: patronymicIsRussian)
        .animation(.easeInOut, value: successResult)
    }
    
    private func editUser() {
        do {
            try Service.service.updateUser(with: user.id, surname: user.surname, name: user.name, patronymic: user.patronymic, phone: user.phone, birthdate: newBirthdate, userTypeID: user.userType.id, password: password)
            successResult = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                cancelAction()
            }
        } catch {
            errorResult = true
        }
    }
}
