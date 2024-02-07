//
//  QueryWithPredicatesAnyAndAllView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.02.2024.
//

import SwiftUI

struct QueryWithPredicatesAnyAndAllView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Запрос, содержащий предикат ANY и ALL")
                    .font(.title)
                    .bold()
                
                Text("Группы студентов, у которых есть задачи, для выполнения которых требуется определенное количество часов (больше или равно), причем это количество часов превышает среднее количество часов для всех задач.")
                
                QueryWithPredicatesAnyAndAllTable()
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
        }
        .padding()
    }
}
