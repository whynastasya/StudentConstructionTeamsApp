//
//  CompositeMultitableQueryWithCaseExpression.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 03.02.2024.
//

import SwiftUI

struct CompositeMultitableQueryWithCaseExpression: View {
    var body: some View {
        VStack {
            VStack {
                Text("Case-выражение")
                    .font(.title)
                    .bold()
                
                Text("Информация о статусе студента в группе: студент или староста")
                
                CompositeMultitableQueryWithCaseExpressionTable()
            }
            .padding()
            .background()
            .clipShape(.rect(cornerRadius: 30))
        }
        .padding()
    }
}



