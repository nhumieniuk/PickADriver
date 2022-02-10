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
                            .frame(minWidth: UIScreen.main.bounds.width / 1.1, minHeight: UIScreen.main.bounds.height/30, alignment: .leading)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .foregroundColor(Color(UIColor.label))
                            .cornerRadius(10)
                            .buttonStyle(PlainButtonStyle())
                    }
                    .simultaneousGesture(TapGesture().onEnded {reset(period: period)})
                    }
                HStack{
                    NavigationLink(destination: EditPeriodsView(driverIndex: driverIndex)){
                        Text("Edit Names")
                            .frame(minWidth: UIScreen.main.bounds.width / 1.35, minHeight: UIScreen.main.bounds.height/30, alignment: .center)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .foregroundColor(Color(UIColor.label))
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: SettingsView(settings: settings, lengthAmount: String(settings.lengthAmount))){
                        Image(systemName: "gear")
                            .resizable()
                            .frame(minWidth: UIScreen.main.bounds.height/30, maxWidth: UIScreen.main.bounds.height/30, minHeight: UIScreen.main.bounds.height/30, maxHeight: UIScreen.main.bounds.height/30)
                            .scaledToFit()
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .foregroundColor(Color(UIColor.label))
                            .cornerRadius(10)
                    }
                }
                
            }
            .navigationTitle("Pick a Driver")
            Spacer()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .foregroundColor(Color(UIColor.label))
        .preferredColorScheme(settings.darkMode ? .dark : .light)
    }
    
    func returnColumnsNeeded(period: Int) -> Int
    {
        let spaceNeeded = Int(UIScreen.main.bounds.height / 58) - 3
        let amountOfColumns = ((periodIndices(period: period).count) / spaceNeeded) + 1
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





