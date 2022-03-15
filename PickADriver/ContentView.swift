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
                            Capsule()
                                .background(Color(UIColor.secondarySystemBackground))
                                .foregroundColor(Color(UIColor.secondarySystemBackground).opacity(0))
                                .cornerRadius(20)
                                .overlay(Text("Period \(period)")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding())
                           
                        }
                        .simultaneousGesture(TapGesture().onEnded {reset(period: period); driverIndex.reset = true})
                    }
                    HStack{
                        NavigationLink(destination: EditPeriodsView(driverIndex: driverIndex)){
                            Capsule()
                                .background(Color(UIColor.secondarySystemBackground))
                                .foregroundColor(Color(UIColor.secondarySystemBackground).opacity(0))
                                .cornerRadius(20)
                                .overlay(Text("Edit Names")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .minimumScaleFactor(0.8)
                                            .lineLimit(1))
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
                .padding(8)
                .opacity(verticalSizeClass == .compact ? 0 : 1)
                
                VStack{
                    ForEach(periods, id: \.self) { period in
                        if(period % 2 == 1){
                        HStack{
                            NavigationLink(destination: NameDisplayView(driverIndex: driverIndex, settings: settings, gridItemLayout: Array(repeating: .init(.flexible()), count: returnColumnsNeeded(period: period)), period: period)) {
                                Capsule()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .foregroundColor(Color(UIColor.secondarySystemBackground).opacity(0))
                                    .cornerRadius(20)
                                    .overlay(Text("Period \(period)")
                                                .frame(maxWidth: .infinity)
                                                .padding())
                                }
                            .simultaneousGesture(TapGesture().onEnded {reset(period: period); driverIndex.reset = true})
                            NavigationLink(destination: NameDisplayView(driverIndex: driverIndex, settings: settings, gridItemLayout: Array(repeating: .init(.flexible()), count: returnColumnsNeeded(period: period + 1)), period: period + 1)) {
                                Capsule()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .foregroundColor(Color(UIColor.secondarySystemBackground).opacity(0))
                                    .cornerRadius(20)
                                    .overlay(Text("Period \(period + 1)")
                                                .frame(maxWidth: .infinity)
                                                .padding())
                                }
                            .simultaneousGesture(TapGesture().onEnded {reset(period: period); driverIndex.reset = true})
                            }
                        }
                    }
                    HStack{
                        NavigationLink(destination: EditPeriodsView(driverIndex: driverIndex)){
                            Capsule()
                                .background(Color(UIColor.secondarySystemBackground))
                                .foregroundColor(Color(UIColor.secondarySystemBackground).opacity(0))
                                .cornerRadius(20)
                                .overlay(Text("Edit Names")
                                            .frame(maxWidth: .infinity)
                                            .padding())
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
                .padding(8)
                .opacity(verticalSizeClass == .compact ? 1 : 0)
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .navigationTitle("Pick a Driver")
        .foregroundColor(Color(UIColor.label))
    }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func returnColumnsNeeded(period: Int) -> Int
    {
        let spaceNeeded = Int(UIScreen.main.bounds.height / 58) - 3
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(driverIndex: DriverIndex(), settings: Settings())
                //.previewDevice("iPod Touch")
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        }
        
    }
}



