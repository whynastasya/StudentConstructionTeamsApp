//
//  EditingUserTypeView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 28.01.2024.
//

import SwiftUI

struct EditingUserTypeView: View {
    @State var title = "Добавление"
    @State var titleButton = "Добавить"
    @State private var userType = UserType(id: 0, name: "")
    @State var userTypeID: Int?
    @State private var nameIsRussian = true
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
                Text("Такое название уже используется")
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.red, lineWidth: 1))
                    .background(.red.opacity(0.1))
            }
            
            if successResultForEditing {
                Text("Тип пользователя изменен")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            if successResultForAdding {
                Text("Тип пользователя добавлен")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            TextField("Название*", text: $userType.name)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
                .onChange(of: userType.name, {
                    nameIsRussian = userType.name.isContainsOnlyRussianCharacters
                })
            
            if !nameIsRussian {
                Text("Допустимые значения - русский алфавит")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
            }
            
            HStack {
                CancelButton(action: cancelAction)
                
                EditButton(action: editUserType, name: titleButton)
                    .disabled(!nameIsRussian || userType.name.isEmpty)
            }
        }
        .padding()
        .onAppear {
            do {
                if let id = userTypeID {
                    userType = try Service.service.fetchUserType(with: id)
                }
            } catch { }
        }
        .animation(.easeInOut, value: nameIsRussian)
        .animation(.easeInOut, value: successResultForAdding)
        .animation(.easeInOut, value: successResultForEditing)
        .animation(.easeInOut, value: errorResult)
        .frame(minWidth: 350, minHeight: 220)
        .background(.black.opacity(0.2))
    }
    
    private func editUserType() {
        if title == "Добавление" {
            do {
                try Service.service.addNewUserType(name: userType.name)
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
                try Service.service.updateUserType(with: userType.id, newName: userType.name)
                successResultForEditing = true
                errorResult = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch {
                errorResult = true
            }
        }
    }
}

