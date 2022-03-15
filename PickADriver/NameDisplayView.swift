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
    @State private var showEmptyAlert = false
    let gridItemLayout: [GridItem]
    let period: Int
    var body: some View {
        Spacer()
        ZStack{
            VStack{
                winnerText
                    .foregroundColor(Color(UIColor.label))
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                Button(action: {reset(period: period)}){
                    ZStack{
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(maxWidth: 50, maxHeight: 50)
                            .foregroundColor(Color(UIColor.secondarySystemBackground))
                        Image(systemName: "arrow.clockwise.circle")
                            .resizable()
                            .frame(maxWidth: 50, maxHeight: 50)
                            .foregroundColor(Color(UIColor.systemBlue))
                        
                    }
                }
            }
            .opacity(winnerShown ? 1 : 0)
            
            LazyVGrid(columns: gridItemLayout, spacing: 8){
                ForEach(driverIndex.names.indices, id: \.self) { index in
                    if(driverIndex.names[index].period == period){
                        Text(driverIndex.names[index].name)
                            .minimumScaleFactor(settings.textScaling ? settings.textScalingSize : 1)
                            .lineLimit(1)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                            .background(Color(UIColor.secondarySystemBackground))
                            .foregroundColor(Color(UIColor.label))
                            .cornerRadius(20)
                            .onTapGesture {
                                driverIndex.names[index].faded.toggle()
                            }
                            .opacity(driverIndex.names[index].faded ? 0.2 : 1)
                            .opacity(driverIndex.names[index].invisible ? 0 : 1)
                    }
                }
            }
            .padding(8)
        }
        Spacer()
        HStack{
        Button("Pick a Driver"){
            var numberOfPeopleGrayedOut = 0
            for i in 0..<currentPeriodIndices().count {
                if(driverIndex.names[currentPeriodIndices()[i]].faded == true){
                    numberOfPeopleGrayedOut += 1
            }
            }
            if(currentPeriodIndices().count - numberOfPeopleGrayedOut != 0 && driverIndex.reset == true){
                driverIndex.reset = false
                selectRandomName(amountOfPeople: currentPeriodIndices().count - 1)
            }
            if(currentPeriodIndices().count - numberOfPeopleGrayedOut == 0)
            {
                showEmptyAlert = true
            }
        }
        .alert(isPresented: $showEmptyAlert) {
            Alert(title: Text("Empty List"), message: Text("There are no names available for selection in the list."), dismissButton: .default(Text("OK")))
        }
        .padding()
        .frame(minHeight: 50, maxHeight: 50, alignment: .center)
        .background(Color(UIColor.secondarySystemBackground))
        .foregroundColor(Color(UIColor.label))
        .cornerRadius(20)
        .opacity(driverIndex.reset ? 1 : 0.5)
        .padding(8)
            Button(action: {reset(period: period)}){
                ZStack{
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(minWidth: 50, maxWidth: 50, minHeight: 50, maxHeight: 50)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(minWidth: 50, maxWidth: 50, minHeight: 50, maxHeight: 50)
                        .foregroundColor(Color(UIColor.systemRed))
                        .opacity(driverIndex.reset ? 0.2 : 1)
                }
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
            if(driverIndex.reset == false){
                if i < amountOfPeople - numberOfPeopleGrayedOut {
                    let randomStudent = Int.random(in: 0..<currentPeriodIndices().count)
                    let removeStudent = DispatchWorkItem {
                        driverIndex.selectingQueue = false
                        if(driverIndex.reset == false){
                        i += 1
                        driverIndex.names[currentPeriodIndices()[randomStudent]].invisible = true
                        nextIteration()
                        }
                    }
                    if(driverIndex.names[currentPeriodIndices()[randomStudent]].invisible == false && driverIndex.reset == false){
                        if(settings.exponentialFormula){
                            if(driverIndex.selectingQueue == true){
                                removeStudent.cancel()
                            }
                            driverIndex.selectingQueue = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + exponentiallyDisappear(lengthAmount: settings.lengthAmount, amountOfPeople: amountOfPeople - numberOfPeopleGrayedOut, index: i), execute: removeStudent)
                        }
                        else{
                            if(driverIndex.selectingQueue == true){
                                removeStudent.cancel()
                            }
                            driverIndex.selectingQueue = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + linearlyDisappear(lengthAmount: settings.lengthAmount, amountOfPeople: amountOfPeople - numberOfPeopleGrayedOut), execute: removeStudent)
                        }
                    }
                    else {
                        if(driverIndex.reset == false){
                        nextIteration()
                        }
                    }
                }
                else {
                    if(driverIndex.reset == false){
                    for i in 0..<currentPeriodIndices().count {
                        if(driverIndex.names[currentPeriodIndices()[i]].invisible == false){
                            driverIndex.names[currentPeriodIndices()[i]].invisible = true
                            winnerText = Text(driverIndex.names[currentPeriodIndices()[i]].name)
                            winnerShown = true
                        }
                    }
                    }
                }
            }
        }
        nextIteration()
    }
    func reset(period: Int){
        for i in 0..<currentPeriodIndices().count {
            driverIndex.names[currentPeriodIndices()[i]].invisible = false
        }
        winnerShown = false
        driverIndex.reset = true
    }
    
    func exponentiallyDisappear(lengthAmount: Double, amountOfPeople: Int, index: Int) -> Double{
        let amountOfPeople = Double(amountOfPeople)
        let index = Double(index)
        if(index + 1 == amountOfPeople){
            return pow(pow(lengthAmount, 1/amountOfPeople), index) - pow(pow(lengthAmount, 1/amountOfPeople), index - 1) + 1
        }
        return pow(pow(lengthAmount, 1/amountOfPeople), index) - pow(pow(lengthAmount, 1/amountOfPeople), index - 1)
    }
    func linearlyDisappear(lengthAmount: Double, amountOfPeople: Int) -> Double{
        return lengthAmount/Double(amountOfPeople)
    }
    
}


