//
//  MenuScreen.swift
//  PickADriver
//
//  Created by Student on 3/3/22.
//

import SwiftUI



struct PeriodsView: View {
    let periods: [Int]
    let settings: Settings
    let driverIndex: DriverIndex
    let verticalRotation: Bool
    var body: some View {
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
                BottomBar(settings: settings, driverIndex: driverIndex)
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .navigationTitle("Pick a Driver")
            .opacity(verticalRotation ? 0 : 1)
            
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
                BottomBar(settings: settings, driverIndex: driverIndex)
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .navigationBarHidden(verticalRotation)
            .opacity(verticalRotation ? 1 : 0)
        }
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



struct BottomBar: View {
    let settings: Settings
    let driverIndex: DriverIndex
    var body: some View {
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
                    .padding(UIScreen.main.bounds.size.height / 12.6 / 5)
                    .foregroundColor(Color(UIColor.label))
            }
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(20)
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

