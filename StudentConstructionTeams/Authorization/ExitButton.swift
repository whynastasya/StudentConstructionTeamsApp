//
//  ExitButton.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct ExitButton: View {
    @StateObject var session: Session
    
    var body: some View {
        Button(
            action: {
                session.currentScreen = .login
            }, label: {
                Text("Выйти")
                    .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
            })
        .buttonStyle(.link)
        .background(Capsule().stroke(.red, lineWidth: 1))
        .foregroundStyle(.red)
    }
}
