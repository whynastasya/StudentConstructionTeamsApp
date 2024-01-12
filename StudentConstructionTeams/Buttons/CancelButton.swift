//
//  CancelButton.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 12.01.2024.
//

import SwiftUI

struct CancelButton: View {
    var action: () -> Void
    var body: some View {
        Button(
            action: {
                action()
            }, label: {
                Text("Отмена")
                    .fontWeight(.bold)
            })
        .padding()
        .background()
        .buttonStyle(.link)
        .clipShape(.rect(cornerRadius: 12))
        .foregroundStyle(.secondary)
    }
}
