//
//  AccountViewInSidebar.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.01.2024.
//

import SwiftUI

struct AccountViewInSidebar: View {
    @State var user = User(id: 0, name: "", surname: "", phone: "", userType: UserType(id: 0, name: ""))
    @ObservedObject var session: Session
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
            
            VStack {
                Text(user.surname + " " + user.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(user.userType.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            do {
                if let user = try Service.service.fetchUser(with: session.userID) {
                    self.user = user
                } else {
                    session.currentScreen = .login
                    session.userID = 0
                }
            } catch {
                
            }
        }
    }
}

//#Preview {
//    AccountViewInSidebar()
//}
