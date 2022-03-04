//
//  ContentView.swift
//  PickADriver
//
//  Created by Student on 2/2/22.
//

import SwiftUI

struct ContentView: View {
    let periods = [1, 2, 3, 4, 5, 6, 7, 8]
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @ObservedObject var driverIndex: DriverIndex
    @ObservedObject var settings: Settings
    var body: some View {
        NavigationView {
                PeriodsView(periods: periods, settings: settings, driverIndex: driverIndex, verticalRotation: verticalSizeClass == .compact)
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .navigationTitle("Pick a Driver")
            
        .foregroundColor(Color(UIColor.label))
        .preferredColorScheme(settings.darkMode ? .dark : .light)
    }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}





