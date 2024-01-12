//
//  ExitButton.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct ExitButton: View {
    @StateObject var session: Session
    @State var isLogoutModalPresented: Bool
    
    var body: some View {
        Button(
            action: {
                if isLogoutModalPresented {
                    session.currentScreen = .login
                    isLogoutModalPresented = false
                } else {
                    isLogoutModalPresented = true
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
