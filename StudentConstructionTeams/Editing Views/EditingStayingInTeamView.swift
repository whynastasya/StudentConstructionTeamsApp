//
//  EditingStayingInTeamView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 02.02.2024.
//

import SwiftUI

struct EditingStayingInTeamView: View {
    @State var title = "Добавление"
    @State var titleButton = "Добавить"
    @State private var stayingInTeam = StayingInTeam(id: 0, team: Team(id: 0, name: "", countStudents: 0), student: Student(id: 0, userID: 0, name: "", surname: "", phone: ""), startDate: Date())
    @State var stayingInTeamID: Int?
    @State private var freeStudents = [Student]()
    @State private var teams = [Team]()
    @State private var newStartDate: Date? = nil
    @State private var newEndDate: Date? = nil
    @State private var studentStayingInTeams = [StayingInTeam]()
    var cancelAction : () -> Void
    @State private var successResultForEditing = false
    @State private var successResultForAdding = false
    @State private var errorDate = false
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.accent)
            
            if successResultForEditing {
                Text("Пребывание в команде изменено")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            if successResultForAdding {
                Text("Пребывание в команде добавлено")
                    .textFieldStyle(.roundedBorder)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                    .background(RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.green, lineWidth: 1))
                    .background(.green.opacity(0.1))
            }
            
            Picker("Выберите студента", selection: $stayingInTeam.student.id ) {
                Text("").tag(0)
                ForEach(freeStudents ?? [Student](), id: \.self) { student in
                    Text(student.fullName).tag(student.id)
                }
            }
            .fontDesign(.rounded)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
            .onChange(of: stayingInTeam.student, {
                do {
                    studentStayingInTeams = try Service.shared.fetchAllStayingInTeamsForStudent(with: stayingInTeam.student.id)
                } catch { }
            })
            
            Picker("Выберите команду", selection: $stayingInTeam.team.id) {
                Text("").tag(0)
                ForEach(teams ?? [Team](), id: \.self) { team in
                    Text(team.name).tag(team.id)
                }
            }
            .fontDesign(.rounded)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
            
            HStack {
                Text("Дата начала")
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 0))
                Spacer()
                DatePicker("", selection: $stayingInTeam.startDate, in: ...Date.now, displayedComponents: .date)
                    .fixedSize()
                    .environment(\.locale, Locale.init(identifier: "ru_RU"))
                    .labelsHidden()
                    .datePickerStyle(.field)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .onChange(of: stayingInTeam.startDate, perform: { value in
                        newStartDate = stayingInTeam.startDate
                        for studentStayingInTeam in studentStayingInTeams {
                            let range = studentStayingInTeam.startDate...studentStayingInTeam.endDate!
                            if range.contains(newStartDate!) {
                                errorDate = true
                            } else {
                                errorDate = false
                            }
                        }
                    })
            }
            
            HStack {
                Text("Дата окончания")
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 0))
                Spacer()
                DatePicker("", selection: $stayingInTeam.endDate.toUnwrapped(defaultValue: Date()), in: ...Date(), displayedComponents: .date)
                    .fixedSize()
                    .environment(\.locale, Locale.init(identifier: "ru_RU"))
                    .labelsHidden()
                    .datePickerStyle(.field)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .onChange(of: stayingInTeam.endDate, perform: { value in
                        newEndDate = stayingInTeam.endDate
                        for studentStayingInTeam in studentStayingInTeams {
                            let range = studentStayingInTeam.startDate...studentStayingInTeam.endDate!
                            if range.contains(newEndDate!) {
                                errorDate = true
                            } else {
                                errorDate = false
                            }
                        }
                    })
            }
            
            if newStartDate ?? Date() > newEndDate ?? Date() {
                Text("Дата начала раньше даты окончания")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
                    .padding()
            }
            
            if errorDate {
                Text("В эту дату студент был в другой команде")
                    .foregroundStyle(.red)
                    .fontDesign(.rounded)
                    .padding()
            }
            
            HStack {
                CancelButton(action: cancelAction)
                
                EditButton(action: editGroup, name: titleButton)
                    .disabled(stayingInTeam.student.id == 0 || stayingInTeam.team.id == 0 || (newEndDate ?? Date() < ((newStartDate ?? Calendar.current.date(byAdding: .day, value: -1, to: Date()))!)) || newStartDate == nil || errorDate)
            }
        }
        .padding()
        .onAppear {
            do {
                if let id = stayingInTeamID {
                    stayingInTeam = try Service.shared.fetchStayingInTeam(with: id)
                }
                freeStudents = try Service.shared.fetchFreeStudents()
                teams = try Service.shared.fetchAllTeams()
            } catch { }
        }
        .animation(.easeInOut, value: successResultForAdding)
        .animation(.easeInOut, value: successResultForEditing)
        .animation(.easeInOut, value: newStartDate ?? Date() > newEndDate ?? Date())
        .frame(minWidth: 320, minHeight: 350)
        .background(.black.opacity(0.2))
    }
    
    private func editGroup() {
        if title == "Добавление" {
            do {
                try Service.shared.addNewStayingInTeam(studentID: stayingInTeam.student.id, teamID: stayingInTeam.team.id, startDate: newStartDate!, endDate: newEndDate)
                successResultForAdding = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch {
                print(error)
            }
        } else {
            do {
                try Service.shared.updateStayingInTeam(with: stayingInTeam.id, newStudentID: stayingInTeam.student.id, newTeamID: stayingInTeam.team.id, newStartDate: newStartDate ?? stayingInTeam.startDate, newEndDate: newEndDate)
                successResultForEditing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cancelAction()
                }
            } catch { } 
        }
    }
}
