//
//  StudentsAdminView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 30.01.2024.
//

import SwiftUI

struct StudentsAdminView: View {
    @StateObject var session: Session
    @State private var students = [Student]()
    @State private var isEditingModalPresented = false
    @State private var isAddingModalPresented = false
    @State private var isDeletingModalPresented = false
    @State private var selectedStudent = Student(id: 0, userID: 0, name: "", surname: "", phone: "")
    
    var body: some View {
        VStack {
            VStack {
                Text("Студенты")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                StudentsAdminTable(session: session, students: students)
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
               content: { EditingStudentView(cancelAction: cancel) })
        .sheet(isPresented: $isEditingModalPresented,
               onDismiss: { loadData() },
               content: { EditingStudentView(title: "Изменение", titleButton: "Изменить", studentID: session.selectedCellID, cancelAction: cancel) })
        .sheet(isPresented: $isDeletingModalPresented,
               onDismiss: { loadData() },
               content: { DeletingView(cancelAction: cancel, deleteAction: deleteStudent, loadData: loadSelectedStudent )})
    }
    
    private func loadData() {
        do {
            students = try Service.shared.fetchAllStudents()
        } catch { }
    }
    
    private func cancel() {
        isAddingModalPresented = false
        isEditingModalPresented = false
        isDeletingModalPresented = false
    }
    
    private func loadSelectedStudent() -> String {
        do {
            selectedStudent = try Service.shared.fetchStudent(with: session.selectedCellID!)!
        } catch { }
        
        return "Студента '\(selectedStudent.fullName)'?"
    }
    
    private func deleteStudent() {
        do {
            try Service.shared.deleteStudent(with: session.selectedCellID!, userID: selectedStudent.userID)
        } catch { print(error) }
        cancel()
    }
}


