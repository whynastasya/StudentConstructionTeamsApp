//
//  ExitButton.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct ExitButton: View {
    var body: some View {
        Button(
            action: {
                Task {
                    do {
                        try Service().fetchTeams()
                    } catch {
                        print("\(String(reflecting: error))")
                    }
                }
            }, label: {
                Text("Выйти")
                    .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
            })
        .buttonStyle(.link)
        .background(Capsule().stroke(.red, lineWidth: 1))
        .foregroundStyle(.red)
    }
}

#Preview {
    ExitButton()
}
