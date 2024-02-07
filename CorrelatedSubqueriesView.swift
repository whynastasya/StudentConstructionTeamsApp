//
//  CorrelatedSubqueriesView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 07.02.2024.
//

import SwiftUI

struct CorrelatedSubqueriesView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Коррелированные подзапросы")
                    .font(.title)
                    .bold()
                
                Text("Информация о заданиях и среднем количестве отработанных часов")
                    .font(.title3)
                
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
            
            VStack {
                Text("Даты рождения студентов в диапазоне этих дат")
                    .font(.title3)
                
                HStack {
                    Text("Первое число:")
                    Picker("", selection: $firstNumber) {
                        ForEach(1900...2024, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    
                    Text("Второе число:")
                    Picker("", selection: $secondNumber) {
                        ForEach(1900...2024, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    
                    AddButton(action: { loadData() }, name: "Обновить")
                        .disabled(firstNumber > secondNumber)
                }
                
                if firstNumber > secondNumber {
                    Text("Второе число должно быть больше первого")
                        .foregroundStyle(.red)
                        .fontDesign(.rounded)
                }
                
                SubqueryFromTable(students: students)
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
            
            VStack {
                Text("Информация о задачах, у которых количество отработанных часов превышает общее среднее количество отработанных часов по всем задачам")
                    .font(.title3)
                SubqueryWhereTable()
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
            
        }
        .padding()
        .onAppear {
            loadData()
        }
        .animation(.easeInOut, value: firstNumber > secondNumber)
    }
    
    private func loadData() {
        do {
            students = try Service.shared.fetchStudentsInBirthdateRange(firstNumber: firstNumber, secondNumber: secondNumber)
        } catch { }
    }
}
