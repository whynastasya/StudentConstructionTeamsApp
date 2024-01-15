//
//  AddingButton.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 13.01.2024.
//

import SwiftUI

struct AddButton: View {
    var action: () -> Void
    var name: String = "Добавить"
    var body: some View {
        Button(
            action: {
                action()
            }, label: {
                Text(name)
                    .fontWeight(.bold)
            })
        .padding()
        .background(.accent)
        .buttonStyle(.link)
        .clipShape(.rect(cornerRadius: 12))
        .foregroundStyle(.white)
    }
}
