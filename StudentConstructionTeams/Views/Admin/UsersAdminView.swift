//
//  UsersAdminView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.01.2024.
//

import SwiftUI

struct UsersAdminView: View {
    @StateObject var session: Session
    @State var isEditingModalPresented = false
    @State var isAddingModalPresented = false
    @State var isDeletingModalPresented = false
    @State var users = [User]()
    @State private var selectedUser = User(id: 0, name: "", surname: "", phone: "", userType: UserType(id: 0, name: ""))
    
    var body: some View {
        VStack {
            VStack {
                Text("Пользователи приложения")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                UsersAdminTable(session: session, users: users)
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
            
            HStack {
                Spacer()
                AddButton(action: { isAddingModalPresented = true } )

                EditButton(action: { isEditingModalPresented = true })
                    .disabled(((session.selectedCellID?.description.isEmpty) == nil))
                DeleteButton(action: {
                    isDeletingModalPresented = true
                })
                    .disabled(((session.selectedCellID?.description.isEmpty) == nil))
                    .foregroundStyle(session.selectedCellID?.description.isEmpty == nil ? .white.opacity(0.5) : .white)
            }
        }
        .padding()
        .onAppear {
            loadData()
        }
        .sheet(isPresented: $isAddingModalPresented,
               onDismiss: { loadData() },
               content: { AdminEditingUserView(cancelAction: cancel) })
        .sheet(isPresented: $isEditingModalPresented,
               onDismiss: { loadData() },
               content: { AdminEditingUserView(
                userID: session.selectedCellID,
                cancelAction: cancel,
                title: "Изменение",
                titleButton: "Изменить"
            )})
        .sheet(isPresented: $isDeletingModalPresented,
               onDismiss: { loadData() },
               content: { DeletingView(cancelAction: cancel, deleteAction: deleteUser, loadData: loadSelectedUser)} )
        
    }
    
    private func loadData() {
        do {
            users = try Service.service.fetchAllUsers()
        } catch { }
    }
    
    private func cancel() {
        isEditingModalPresented = false
        isAddingModalPresented = false
        isDeletingModalPresented = false
    }
    
    private func deleteUser() {
        do {
            try Service.service.deleteUser(with: session.selectedCellID!)
        } catch { print(error )}
        cancel()
    }
    
    private func loadSelectedUser() -> String {
        do {
            selectedUser = try Service.service.fetchUser(with: session.selectedCellID!)!
        } catch { }
        return "Пользователя '\(selectedUser.fullName)'?"
    }
}
