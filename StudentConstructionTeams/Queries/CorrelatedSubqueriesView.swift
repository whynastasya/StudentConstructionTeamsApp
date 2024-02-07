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
                CorrelatedSubquerySelectTable()
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
            
            VStack {
                Text("Информация о командах и общем заработке студентов в каждой команде, учитывая только тех студентов, у которых заработок превышает средний заработок в команде")
                    .font(.title3)
                CorrelatedSubqueryFromTable()
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
            
            VStack {
                Text("Студенты, которые участвуют в командах, где хотя бы одно задание имеет статус 'Завершено'")
                    .font(.title3)
                CorrelatedSubqueryWhereTable()
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
            
        }
        .padding()
    }
}
