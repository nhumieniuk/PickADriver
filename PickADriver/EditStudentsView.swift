//
//  EditStudentsView.swift
//  PickADriver
//
//  Created by Student on 2/2/22.
//

import SwiftUI

struct EditStudentsView: View {
    @ObservedObject var driverIndex: DriverIndex
    @ObservedObject var settings: Settings
    @State var showingPaymentAlert = false
    @State private var showingAddView = false
    @State private var i = 0
    let period: Int
    var body: some View {
        List{
            ForEach(driverIndex.names) { student in
                if(student.period == period){
                    Text(student.name)
                }
            }
            .onDelete(perform: { indexSet in
                        driverIndex.names.remove(atOffsets: indexSet)  })
            .onMove(perform: { indexSet, newOffset in
                driverIndex.names.move(fromOffsets: indexSet, toOffset:  newOffset)
            })
            Button("CLEAR ALL")
            {
                showingPaymentAlert = true
            }
            .foregroundColor(Color.red)
            .alert(isPresented: $showingPaymentAlert) {
                Alert(title: Text("Are you sure you want to clear all names in this period?"), message: Text("This action cannot be undone."), primaryButton: .destructive(Text("Clear Names"), action: {deleteNames()}), secondaryButton: .cancel(Text("Cancel")))
            }
        }
        .sheet(isPresented: $showingAddView, content: {  AddView(driverIndex: driverIndex, settings: settings, period: period)
        })
        .navigationBarItems(leading: EditButton(), trailing: Button(action:{
                                                                        showingAddView = true}) {  Image(systemName: "plus")  })
    }
    
    func deleteNames(){
        var namesToRemove = [Int]()
        for i in 0..<currentPeriodIndices().count {
            namesToRemove.append(currentPeriodIndices()[i])
        }
        driverIndex.names.remove(at: namesToRemove)
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
}

extension Array {
    mutating func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            remove(at: index)
        }
    }
}




