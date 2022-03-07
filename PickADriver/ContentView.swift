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
            ZStack{
                VStack{
                    ForEach(periods, id: \.self) { period in
                        NavigationLink(destination: NameDisplayView(driverIndex: driverIndex, settings: settings, gridItemLayout: Array(repeating: .init(.flexible()), count: returnColumnsNeeded(period: period)), period: period)) {
                            Text("Period \(period)")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Color(UIColor.secondarySystemBackground))
                                .foregroundColor(Color(UIColor.label))
                                .cornerRadius(20)
                        }
                        .simultaneousGesture(TapGesture().onEnded {reset(period: period)})
                    }
                    HStack{
                        NavigationLink(destination: EditPeriodsView(driverIndex: driverIndex, settings: settings)){
                            Text("Edit Names")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color(UIColor.secondarySystemBackground))
                                .foregroundColor(Color(UIColor.label))
                                .cornerRadius(20)
                        }
                        NavigationLink(destination: SettingsView(settings: settings, lengthAmount: String(settings.lengthAmount))){
                            Image(systemName: "gear")
                                .resizable()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(UIScreen.main.nativeBounds.size.width / 12.6 / 5)
                                .foregroundColor(Color(UIColor.label))
                        }
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(20)
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .topLeading)
                .navigationTitle("Pick a Driver")
                .opacity(verticalSizeClass == .compact ? 0 : 1)
                
                VStack{
                    ForEach(periods, id: \.self) { period in
                        if(period % 2 == 1){
                        HStack{
                            NavigationLink(destination: NameDisplayView(driverIndex: driverIndex, settings: settings, gridItemLayout: Array(repeating: .init(.flexible()), count: returnColumnsNeeded(period: period)), period: period)) {
                                Text("Period \(period)")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .foregroundColor(Color(UIColor.label))
                                    .cornerRadius(20)
                                }
                            NavigationLink(destination: NameDisplayView(driverIndex: driverIndex, settings: settings, gridItemLayout: Array(repeating: .init(.flexible()), count: returnColumnsNeeded(period: period + 1)), period: period + 1)) {
                                Text("Period \(period + 1)")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .foregroundColor(Color(UIColor.label))
                                    .cornerRadius(20)
                                }

                            }
                        }
                    }
                    HStack{
                        NavigationLink(destination: EditPeriodsView(driverIndex: driverIndex, settings: settings)){
                            Text("Edit Names")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color(UIColor.secondarySystemBackground))
                                .foregroundColor(Color(UIColor.label))
                                .cornerRadius(20)
                        }
                        NavigationLink(destination: SettingsView(settings: settings, lengthAmount: String(settings.lengthAmount))){
                            Image(systemName: "gear")
                                .resizable()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(UIScreen.main.nativeBounds.size.width / 12.6 / 5)
                                .foregroundColor(Color(UIColor.label))
                        }
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(20)
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.size.height, alignment: .topLeading)
                .navigationBarHidden(verticalSizeClass == .compact)
                .opacity(verticalSizeClass == .compact ? 1 : 0)
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .navigationTitle("Pick a Driver")
            
        .foregroundColor(Color(UIColor.label))
        .preferredColorScheme(settings.darkMode ? .dark : .light)
    }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func returnColumnsNeeded(period: Int) -> Int
    {
        let spaceNeeded = Int(UIScreen.main.bounds.height / 58) - 2
        let amountOfColumns = ((periodIndices(period: period).count - 1) / spaceNeeded) + 1
        if(amountOfColumns < settings.minNumberOfColumns && settings.minNumberOfColumns <= periodIndices(period: period).count)
        {
            return settings.minNumberOfColumns
        }
        if(settings.minNumberOfColumns > periodIndices(period: period).count){
            return periodIndices(period: period).count
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





