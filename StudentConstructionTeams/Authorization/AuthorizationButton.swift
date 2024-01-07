//
//  AuthorizationButton.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 06.01.2024.
//

import SwiftUI

struct AuthorizationButton: View {
    var action: () -> Void
    var text: String
    
    var body: some View {
        Button(
            action: {
                action()
            }, label: {
                Text(text)
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
                    .fontDesign(.rounded)
            })
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .clipShape(.capsule)
    }
}

//#Preview {
//    AuthorizationButton(action: () -> Void, text: "Button")
//}
