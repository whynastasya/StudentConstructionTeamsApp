//
//  LoginView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 04.01.2024.
//

import SwiftUI

struct LoginView: View {
    private var phone: String
    var body: some View {
        HStack {
            Image("login")
                .resizable()
                .frame(width: 250, height: 250)
            VStack {
                Text("Login")
                TextField(text: phone, label: <#T##() -> Label#>)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
