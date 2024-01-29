//
//  EditingStudentGroup.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.01.2024.
//

import SwiftUI

struct EditingStudentGroupView: View {
    @StateObject var session: Session
    @State var selectedGroup: Group.ID = 0
    @State var groups: [Group]?
    var cancelAction: () -> Void
    @State private var successResult = false
    
    var body: some View {
        VStack {
            Text("Редактирование")
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.accent)
            
            if successResult {
                Text("Данные группы пользователя изменены")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            Picker("Выберите группу", selection: $selectedGroup) {
                Text("Нет группы").tag(0)
                ForEach(groups ?? [Group](), id: \.self) { group in
                    Text(group.name).tag(group.id)
                }
            }
            .fontDesign(.rounded)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
            
            HStack {
                CancelButton(action: cancelAction)
                EditButton(action: editStudentGroup)
            }
        }
        .padding()
        .background(.black.opacity(0.2))
        .animation(.easeInOut, value: successResult)
        .frame(minWidth: 350, minHeight: 210)
        .onAppear {
            do {
                groups = try Service.shared.fetchAllGroups()
            } catch { }
        }
    }
    
    private func editStudentGroup() {
        do {
            try Service.shared.updateGroupForStudent(userID: session.userID, groupID: selectedGroup)
        } catch { }
        successResult = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            cancelAction()
        }
    }
}


