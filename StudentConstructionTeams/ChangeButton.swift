//
//  ChangeButton.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct ChangeButton: View {
    var body: some View {
        Button(
            action: {
                
            }, label: {
                Text("Изменить")
            })
        .buttonStyle(.link)
        .padding()
        .background()
        .clipShape(.rect(cornerRadius: 12))
        .foregroundStyle(.purple)
    }
}

#Preview {
    ChangeButton()
}
