//
//  AdminEditingUserView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 27.01.2024.
//

import SwiftUI

struct AdminEditingUserView: View {
    @State private var user = User(id: 0, name: "", surname: "", patronymic: "", phone: "", userType: UserType(id: 0, name: ""))
    @State var userID: Int?
    @State private var surnameIsRussian = true
    @State private var nameIsRussian = true
    @State private var patronymicIsRussian = true
    @State private var phoneIsNumber = true
    @State private var newBirthdate: Date? = nil
    @State var password = ""
    var cancelAction: () -> Void
    @State private var errorResult = false
    @State private var successResultForEditing = false
    @State private var successResultForAdding = false
    @State private var userTypes = [UserType]()
    @State var title = "Добавление"
    @State var titleButton = "Добавить"
    
    var body: some View {
        VStack {
            Text(title)
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
            
            if successResultForEditing {
                Text("Данные пользователя изменены")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            if successResultForAdding {
                Text("Данные пользователя добавлены")
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
            
            TextField("Номер телефона*", text: $user.phone)
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
            
            Picker("Тип пользователя*", selection: $user.userType.id) {
                Text("").tag(0)
                ForEach(userTypes, id: \.self) { userType in
                    Text(userType.name).tag(userType.id)
                }
            }
            .fontDesign(.rounded)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
            
            HStack {
                CancelButton(action: cancelAction)
                
                EditButton(action: editUser, name: titleButton)
                    .disabled(!surnameIsRussian || user.surname.isEmpty || !nameIsRussian || user.name.isEmpty || !patronymicIsRussian || !phoneIsNumber || user.phone.isEmpty || (user.userType.id == 0))
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
        .animation(.easeInOut, value: successResultForEditing)
        .animation(.easeInOut, value: successResultForAdding)
        .onAppear {
            do {
                userTypes = try Service.shared.fetchAllUserTypes()
                if let id = userID {
                    user = try Service.shared.fetchUser(with: id)!
                }
            } catch { }
        }
    }
    
    private func editUser() {
        if title == "Добавление" {
            do {
                try Service.shared.addNewUser(phone: user.phone, surname: user.surname, name: user.name, patronymic: user.patronymic, birthdate: user.birthdate, userTypeID: user.userType.id, userTypeName: user.userType.name)
                successResultForAdding = true
                errorResult = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch {
                errorResult = true
                print(error)
            }
        } else {
            do {
                try Service.shared.adminUpdateUser(with: user.id, phone: user.phone, surname: user.surname, name: user.name, patronymic: user.patronymic, birthdate: user.birthdate, userTypeID: user.userType.id)
                successResultForEditing = true
                errorResult = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch {
                errorResult = true
                print(error)
            }
        }
    }
}
