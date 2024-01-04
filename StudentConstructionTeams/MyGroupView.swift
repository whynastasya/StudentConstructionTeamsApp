//
//  MyGroupView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct MyGroupView: View {
    @State var groupInformation = GeneralInformation(groupName: "БСБО-02-21", elder: .init(name: "Иван Иваныч", phone: "12341234"), countStudents: 25)
    @State var students = [Student]()
    var body: some View {
        VStack {
            GeneralInformationView(information: groupInformation)
            MyGroupTable()
        }
        .padding()
    }
}

#Preview {
    MyGroupView()
}
