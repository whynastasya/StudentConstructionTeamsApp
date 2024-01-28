//
//  UserTypesAdminView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 28.01.2024.
//

import SwiftUI

struct UserTypesAdminView: View {
    @StateObject var session: Session
    @State private var userTypes = [UserType]()
    @State private var isEditingModalPresented = false
    @State private var isAddingModalPresented = false
    @State private var isDeletingModalPresented = false
    @State private var selectedUserType = UserType(id: 0, name: "")
    
    var body: some View {
        VStack {
            VStack {
                Text("Типы пользователей")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                UserTypesAdminTable(session: session, userTypes: userTypes)
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
            
            HStack {
                Spacer()
                AddButton(action: { isAddingModalPresented = true })
                EditButton(action: { isEditingModalPresented = true })
                    .disabled(((session.selectedCellID?.description.isEmpty) == nil))
                DeleteButton(action: { isDeletingModalPresented = true })
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
               content: { EditingUserTypeView(cancelAction: cancel)})
        .sheet(isPresented: $isEditingModalPresented,
               onDismiss: { loadData() },
               content: { EditingUserTypeView(title: "Изменение", titleButton: "Изменить", userTypeID: session.selectedCellID, cancelAction: cancel) })
        .sheet(isPresented: $isDeletingModalPresented,
               onDismiss: { loadData() },
               content: { DeletingView(cancelAction: cancel, deleteAction: deleteUserType, loadData: loadSelectedUserType )})
    }
    
    private func loadData() {
        do {
            userTypes = try Service.service.fetchAllUserTypes()
        } catch { }
    }
    
    private func cancel() {
        isAddingModalPresented = false
        isEditingModalPresented = false
        isDeletingModalPresented = false
    }
    
    private func loadSelectedUserType() -> String {
        do {
            selectedUserType = try Service.service.fetchUserType(with: session.selectedCellID!)
        } catch { }
        
        return "Тип пользователя '\(selectedUserType.name)'?"
    }
    
    private func deleteUserType() {
        do {
            try Service.service.deleteUserType(with: session.selectedCellID!)
        } catch { }
        cancel()
    }
}

