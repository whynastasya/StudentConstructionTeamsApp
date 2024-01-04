//
//  MyEarningsView.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 20.12.2023.
//

import SwiftUI

struct MyEarningsView: View {
    @State var earningsInformation = GeneralInformation(allEarnings: 12345, currentMonthEarnings: 654)
    var body: some View {
        VStack {
            GeneralInformationView(information: earningsInformation)
            EarningsOnMonthsChart()
        }
        .padding()
    }
}

#Preview {
    MyEarningsView()
}
