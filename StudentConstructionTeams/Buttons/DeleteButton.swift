//
//  DeleteButton.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.01.2024.
//

import SwiftUI

struct DeleteButton: View {
    var action: () -> Void
    var name: String = "Удалить"
    
    var body: some View {
        Button(
            action: {
                action()
            }, label: {
                Text(name)
                    .fontWeight(.bold)
            })
        .padding()
        .background(.red)
        .buttonStyle(.link)
        .clipShape(.rect(cornerRadius: 12))
//        .foregroundStyle(.white)
    }
}
