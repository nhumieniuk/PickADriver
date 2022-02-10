//
//  NameDisplayView.swift
//  PickADriver
//
//  Created by Student on 2/2/22.
//

import SwiftUI

struct NameDisplayView: View {
    @ObservedObject var driverIndex: DriverIndex
    @ObservedObject var settings: Settings
    @State private var winnerText = Text("")
    @State private var winnerShown = false
    let gridItemLayout: [GridItem]
    let period: Int
    var body: some View {
        ZStack{
            VStack{
                winnerText
                    .foregroundColor(Color(UIColor.label))
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                Button("reset")
                {
                    for i in 0..<currentPeriodIndices().count {
                        driverIndex.names[currentPeriodIndices()[i]].invisible = false
                    }
                    winnerShown = false
                    winnerText = Text("")
                }
                .foregroundColor(Color(UIColor.systemBlue))
                .opacity(winnerShown ? 1 : 0)
            }
            
            LazyVGrid(columns: gridItemLayout, spacing: 8){
                ForEach(driverIndex.names.indices, id: \.self) { index in
                    if(driverIndex.names[index].period == period){
                        Text(driverIndex.names[index].name)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                            .background(Color(UIColor.secondarySystemBackground))
                            .foregroundColor(Color(UIColor.label))
                            .cornerRadius(10)
                            .onTapGesture {
                                driverIndex.names[index].faded.toggle()
                            }
                            .opacity(driverIndex.names[index].faded ? 0.2 : 1)
                            .opacity(driverIndex.names[index].invisible ? 0 : 1)
                    }
                }
            }
        }
        Button("Select a random person"){
            if(currentPeriodIndices().count != 0){
                selectRandomName(amountOfPeople: currentPeriodIndices().count - 1)
            }
        }
    }
    
    func currentPeriodIndices() -> Array<Int> {
        let allStudents = driverIndex.names
        var currentPeriodIndices = [Int]()
        for i in 0..<allStudents.count {
            if(allStudents[i].period == period)
            {
                currentPeriodIndices.append(i)
            }
        }
        return currentPeriodIndices
    }
    func selectRandomName(amountOfPeople: Int){
        var numberOfPeopleGrayedOut = 0
        var i = 0
        for j in 0..<currentPeriodIndices().count {
            if(driverIndex.names[currentPeriodIndices()[j]].faded == true){
                driverIndex.names[currentPeriodIndices()[j]].invisible = true
                numberOfPeopleGrayedOut += 1
                
            }
        }
        func nextIteration() {
            if i < amountOfPeople - numberOfPeopleGrayedOut {
                let randomStudent = Int.random(in: 0..<currentPeriodIndices().count)
                if driverIndex.names[currentPeriodIndices()[randomStudent]].invisible == false {
                    
                    if(settings.exponentialFormula){
                        DispatchQueue.main.asyncAfter(deadline: .now() + exponentiallyDisappear(lengthAmount: settings.lengthAmount, amountOfPeople: amountOfPeople - numberOfPeopleGrayedOut, index: i)) {
                            i += 1
                            driverIndex.names[currentPeriodIndices()[randomStudent]].invisible = true
                            nextIteration()
                        }
                    }
                    else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + linearlyDisappear(lengthAmount: settings.lengthAmount, amountOfPeople: amountOfPeople - numberOfPeopleGrayedOut)) {
                            i += 1
                            driverIndex.names[currentPeriodIndices()[randomStudent]].invisible = true
                            nextIteration()
                        }
                    }
                    
                    
                }
                else {
                    nextIteration()
                }
            }
            else {
                for i in 0..<currentPeriodIndices().count {
                    if(driverIndex.names[currentPeriodIndices()[i]].invisible == false){
                        driverIndex.names[currentPeriodIndices()[i]].invisible = true
                        winnerText = Text(driverIndex.names[currentPeriodIndices()[i]].name)
                        winnerShown = true
                    }
                }
            }
        }
        nextIteration()
        
    }
    
    func exponentiallyDisappear(lengthAmount: Double, amountOfPeople: Int, index: Int) -> Double{
        return (pow(pow(lengthAmount, Double(1.0/(Double(amountOfPeople) + 1.0))), (Double(index) + 2))) - (pow(pow(lengthAmount, Double(1.0/(Double(amountOfPeople) + 1.0))), (Double(index) +  1)))
    }
    func linearlyDisappear(lengthAmount: Double, amountOfPeople: Int) -> Double{
        return lengthAmount/Double(amountOfPeople + 1)
    }
    
}


