//
//  EditPeriodsView.swift
//  PickADriver
//
//  Created by Student on 2/2/22.
//

import SwiftUI

struct EditPeriodsView: View {
    @State var showingClearAlert = false
    @ObservedObject var driverIndex: DriverIndex
    var body: some View {
        List{
            ForEach(driverIndex.periods.indices, id: \.self) { period in
                NavigationLink(destination: EditStudentsView(driverIndex: driverIndex, period: period)) {
                    Text(driverIndex.periods[period])
                }
            }
            
            Button("CLEAR ALL")
            {
                showingClearAlert = true
            }
            .foregroundColor(Color.red)
            .alert(isPresented: $showingClearAlert) {
                Alert(title: Text("Are you sure you want to clear every period?"), message: Text("This action cannot be undone."), primaryButton: .destructive(Text("Clear All"), action: {driverIndex.names.removeAll()}), secondaryButton: .cancel(Text("Cancel")))
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Edit Titles", destination: EditPeriodNamesView(driverIndex: driverIndex))
            }
        }
    }
    
    
}

