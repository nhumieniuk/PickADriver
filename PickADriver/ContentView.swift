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
    @ObservedObject var settings: Settings
    var body: some View {
        NavigationView {
            VStack {
                ForEach(periods, id: \.self) { period in
                    NavigationLink(destination: NameDisplayView(driverIndex: driverIndex, settings: settings, gridItemLayout: Array(repeating: .init(.flexible()), count: returnColumnsNeeded(period: period)), period: period)) {
                        Text("Period \(period)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .foregroundColor(Color(UIColor.label))
                            .cornerRadius(20)
                            .minimumScaleFactor(0.5)
                    }
                    .simultaneousGesture(TapGesture().onEnded {reset(period: period)})
                    }
                HStack{
                    NavigationLink(destination: EditPeriodsView(driverIndex: driverIndex, settings: settings)){
                        Text("Edit Names")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .foregroundColor(Color(UIColor.label))
                            .cornerRadius(20)
                            .minimumScaleFactor(0.5)
                    }
                    NavigationLink(destination: SettingsView(settings: settings, lengthAmount: String(settings.lengthAmount))){
                        Image(systemName: "gear")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .foregroundColor(Color(UIColor.label))
                            .cornerRadius(20)
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
                
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .navigationTitle("Pick a Driver")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .foregroundColor(Color(UIColor.label))
        .preferredColorScheme(settings.darkMode ? .dark : .light)
    }
    
    
    func returnColumnsNeeded(period: Int) -> Int
    {
        let spaceNeeded = Int(UIScreen.main.bounds.height / 58) - 2
        let amountOfColumns = ((periodIndices(period: period).count - 1) / spaceNeeded) + 1
        if(amountOfColumns < settings.minNumberOfColumns && settings.minNumberOfColumns <= periodIndices(period: period).count)
        {
            return settings.minNumberOfColumns
        }
        return amountOfColumns
    }
    func periodIndices(period: Int) -> Array<Int> {
        let allStudents = driverIndex.names
        var periodIndices = [Int]()
        for i in 0..<allStudents.count {
            if(allStudents[i].period == period)
            {
                periodIndices.append(i)
            }
        }
        return periodIndices
    }
    func reset(period: Int){
        for i in 0..<periodIndices(period: period).count {
            driverIndex.names[periodIndices(period: period)[i]].invisible = false
        }
        
    }
    
}





