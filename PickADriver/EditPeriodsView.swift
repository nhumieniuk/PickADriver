//
//  EditPeriodsView.swift
//  PickADriver
//
//  Created by Student on 2/2/22.
//

import SwiftUI

struct EditPeriodsView: View {
    @State var showingPaymentAlert = false
    @ObservedObject var driverIndex: DriverIndex
    @ObservedObject var settings: Settings
    var body: some View {
        let periods = [1, 2, 3, 4, 5, 6, 7, 8]
            List{
                ForEach(periods, id: \.self) { period in
                    NavigationLink(destination: EditStudentsView(driverIndex: driverIndex, settings: settings, period: period)) {
                        Text("Period \(period)")
                    }
                }
                
                Button("CLEAR ALL")
                {
                    showingPaymentAlert = true
                }
                .foregroundColor(Color.red)
                .alert(isPresented: $showingPaymentAlert) {
                    Alert(title: Text("Are you sure you want to delete ALL names?"), message: Text("This action cannot be undone."), primaryButton: .destructive(Text("Delete Names"), action: {driverIndex.names.removeAll()}), secondaryButton: .cancel(Text("Cancel")))
                }
            }
    }
    
}

