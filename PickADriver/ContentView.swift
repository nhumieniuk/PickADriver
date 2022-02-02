//
//  ContentView.swift
//  PickADriver
//
//  Created by Student on 2/2/22.
//

import SwiftUI

struct ContentView: View {
    let periods = [1, 2, 3, 4, 5, 6, 7, 8]
    @ObservedObject var driverIndex: DriverIndex
    var body: some View {
        NavigationView {
            VStack {
                ForEach(periods, id: \.self) { period in
                    NavigationLink(destination: NameDisplayView(driverIndex: driverIndex, period: period)) {
                        Text("Period \(period)")
                    }
                    .padding()
                }
                NavigationLink("Open View", destination: EditPeriodsView(driverIndex: driverIndex))
                    .padding()
                    .foregroundColor(Color.green)
                    .background(Color.red)
                    .frame(width: 200, height: 200)
                    .cornerRadius(100)
            }
            .navigationTitle("Pick a Driver")
        }
    }
}
//struct CustomNavigationView: View {
    //var period: Int
  //  var body: some View {
    //    NavigationLink(destination: NameDisplayView(driverIndex: driverIndex, period: period)) {
      //      Text("Period \(period)")
        //}
      //  .font(.title)
        //.padding()
  //  }
//}





