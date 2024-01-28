//
//  DeletingView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 27.01.2024.
//

import SwiftUI

struct DeletingView: View {
    @State private var text = ""
    var cancelAction: () -> Void
    var deleteAction: () -> Void
    var loadData: () -> String
    
    var body: some View {
        VStack {
            Text("Удалить")
                .font(.title)
                .foregroundStyle(.red)
            
            Text(text)
                .bold()
                .padding()
            
            HStack {
                CancelButton(action: cancelAction)
                DeleteButton(action: deleteAction)
                    .foregroundStyle(.white)
            }
        }
        .padding()
        .onAppear{ text = loadData() }
        .frame(minWidth: 400, minHeight: 200)
        .background(.black.opacity(0.2))
    }
}

