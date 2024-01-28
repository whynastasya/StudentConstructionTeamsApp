//
//  MyAccountView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct MyAccountView: View {
    @State var user = User(id: 0, name: "", surname: "", phone: "", userType: UserType(id: 0, name: ""))
    @StateObject var session: Session
    @State var isEditingModalPresented = false
    @State var isLogoutModalPresented = false
    
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
                    Text(makeDateOnRussian(date: birthdate))
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
            
            HStack {
                Spacer()
                EditButton(action: editUser)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                ExitButton(session: session, isLogoutModalPresented: isLogoutModalPresented)
            }
        }
        .padding()
        .sheet(isPresented: $isLogoutModalPresented) {
            
        }
        .sheet(isPresented: $isEditingModalPresented, onDismiss: {
            loadData()
        }, content: {
            EditingUserView(user: user, cancelAction: cancel)
        })
        .onAppear {
            loadData()
        }
    }
    
    private func editUser() {
        isEditingModalPresented = true
    }
    
    private func cancel() {
        isEditingModalPresented = false
    }
    
    private func loadData() {
        do {
            if let user = try Service.shared.fetchUser(with: session.userID) {
                self.user = user
            } else {
                session.currentScreen = .login
                session.userID = 0
            }
        } catch {}
    }
    
    private func makeDateOnRussian(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM YYYY"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
}
