//
//  AccountViewInSidebar.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 08.01.2024.
//

import SwiftUI

struct AccountViewInSidebar: View {
    var user: any UserProtocol
    var accountType: String
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
            
            VStack {
                Text(user.surname + " " + user.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(accountType)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
            }
        }
    }
}

//#Preview {
//    AccountViewInSidebar()
//}
