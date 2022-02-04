//
//  NameDisplayView.swift
//  PickADriver
//
//  Created by Student on 2/2/22.
//

import SwiftUI

struct NameDisplayView: View {
    @ObservedObject var driverIndex: DriverIndex
    @State var currentPeriodStudents = [Int()]
    @State var viewNumber = 0
    let period: Int
    var body: some View {
        
        Button("reset")
        {
            for i in 0..<currentPeriodIndices().count {
                driverIndex.names[currentPeriodIndices()[i]].invisible = false
            }
        }
        Button("Select a random person"){
            selectRandomName(amountOfPeople: currentPeriodIndices().count - 1)
        }
        
        ForEach(driverIndex.names.indices, id: \.self) { index in
            HStack{
                if(driverIndex.names[index].period == period){
                    VStack{
                        Text(driverIndex.names[index].name)
                            .onTapGesture {
                                driverIndex.names[index].faded.toggle()
                            }
                            .opacity(driverIndex.names[index].faded ? 0.2 : 1)
                            .opacity(driverIndex.names[index].invisible ? 0 : 1)
                    }
                }
            }
        }
       // ForEach(driverIndex.names, id: \.self) { student in
       //     HStack{
       //     if(student.period == period){
       //             VStack{
       //                 Print(student)
       //                 Text(student.name)
       //                     .onTapGesture {
       //                         driverIndex.names[0].faded.toggle()
       //                     }
       //                     .opacity(student.faded ? 0.2 : 1)
       //                     .opacity(student.invisible ? 0 : 1)
       //             }
       //         }
       //     }
       // }
        
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
        var i = 0
        
        for j in 0..<currentPeriodIndices().count {
            if(driverIndex.names[currentPeriodIndices()[j]].faded == true){
                driverIndex.names[currentPeriodIndices()[j]].invisible = true
                i += 1
            }
        }
        
        func nextIteration() {
            if i < amountOfPeople {
                let randomStudent = Int.random(in: 0..<currentPeriodIndices().count)
                
                if driverIndex.names[currentPeriodIndices()[randomStudent]].invisible == false {
                    driverIndex.names[currentPeriodIndices()[randomStudent]].invisible = true
                    print("yeah")
                    i += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    nextIteration()
                    }
                }
                else {
                    nextIteration()
                    print("a")
                }
            }
            else {
                for i in 0..<currentPeriodIndices().count {
                    if(driverIndex.names[currentPeriodIndices()[i]].invisible == false){
                        print(driverIndex.names[currentPeriodIndices()[i]].name, " won")
                    }
                }
            }
        }
        nextIteration()
        
       
           

    }
    
    
    struct CustomTextView: View {
        
        let text: String
        var student: Name
        var body: some View {
            Text(text)
               
        }
    }

    
}
    
extension MutableCollection {
  mutating func updateEach(_ update: (inout Element) -> Void) {
    for i in indices {
      update(&self[i])
    }
  }
}
    
extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}



