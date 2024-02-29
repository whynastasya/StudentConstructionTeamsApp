//
//  AdminEditingGroup.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 28.01.2024.
//

import SwiftUI

struct AdminEditingGroupView: View {
    @State var title = "Добавление"
    @State var titleButton = "Добавить"
    @State private var group = Group(id: 0, name: "", faculty: "")
    @State var groupID: Int?
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
                Text("Группа изменена")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            if successResultForAdding {
                Text("Группа добавлена")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            TextField("Название*", text: $group.name)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
            
            TextField("Факультет*", text: $group.faculty)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .fontDesign(.rounded)
            
            HStack {
                CancelButton(action: cancelAction)
                
                EditButton(action: editGroup, name: titleButton)
                    .disabled(group.name.isEmpty || group.faculty.isEmpty)
            }
        }
        .padding()
        .onAppear {
            do {
                if let id = groupID {
                    group = try Service.shared.fetchStudentGroup(with: id)
                }
            } catch { }
        }
        .animation(.easeInOut, value: successResultForAdding)
        .animation(.easeInOut, value: successResultForEditing)
        .animation(.easeInOut, value: errorResult)
        .frame(minWidth: 320, minHeight: 320)
        .background(.black.opacity(0.2))
    }
    
    private func editGroup() {
        if title == "Добавление" {
            do {
                try Service.shared.addGroup(with: group.name, faculty: group.faculty)
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
                try Service.shared.updateGroup(with: group.id, newName: group.name, newFaculty: group.faculty)
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

