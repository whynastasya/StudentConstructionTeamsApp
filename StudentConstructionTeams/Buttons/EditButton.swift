//
//  ChangeButton.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct EditButton: View {
    var action: () -> Void
    var body: some View {
        Button(
            action: {
                action()
            }, label: {
                Text("Изменить")
                    .fontWeight(.bold)
            })
        .padding()
        .background()
        .buttonStyle(.plain)
        .clipShape(.rect(cornerRadius: 12))
        .foregroundStyle(.orange)
    }
}
