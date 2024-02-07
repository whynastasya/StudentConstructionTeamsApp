//
//  MultitableQueryWithGroupingView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.02.2024.
//

import SwiftUI

struct MultitableQueryWithGroupingView: View {
    @State private var teams = [Team]()
    @State private var earnings: String = "200"
    @State private var earningsIsNumber = true
    
    var body: some View {
        VStack {
            VStack {
                Text("Многотабличный запрос")
                    .font(.title)
                    .bold()
                
                Text("Команды и среднее количество студентов в командах, у которых средний заработок выше определенного порога")
                    .font(.title3)
                
                HStack {
                    TextField("Минимальный заработок", text: $earnings)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                        .fontDesign(.rounded)
                        .onChange(of: earnings, {
                            earningsIsNumber = earnings.isNumber
                        })
                    
                    
                    AddButton(action: loadData, name: "Обновить")
                        .disabled(!earningsIsNumber)
                }
                
                if !earningsIsNumber {
                    Text("Допустимые значения - цифры")
                        .foregroundStyle(.red)
                        .fontDesign(.rounded)
                }
                
                MultitableQueryWithGroupingTable(teams: teams)
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
            .onAppear {
                loadData()
            }
            .animation(.easeInOut, value: earningsIsNumber)
        }
        .padding()
    }
    
    private func loadData() {
        do {
            teams = try Service.shared.fetchTeamsForMultitableQueryWithGrouping(earnings: Int(earnings) ?? 200)
        } catch { }
    }
}
