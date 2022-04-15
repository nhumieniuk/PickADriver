//
//  ImportExportView.swift
//  PickADriver
//
//  Created by Student on 4/14/22.
//

import SwiftUI

struct ImportExportView: View {
    @ObservedObject var driverIndex: DriverIndex
    @Environment(\.presentationMode) var presentationMode
    @State var selection = Set<Int>()
    @State var listsArray = [""]
    @State var lists = ""
    let export: Bool
    var body: some View {
        NavigationView {
            
            Section(header: Text("Select group(s) to \(export ? "export" : "import")").font(.headline)){
                List(driverIndex.periods.indices, id: \.self, selection: $selection) { period in
                    Text(driverIndex.periods[period])
                    }
                Button("Generate"){
                    listsArray = [""]
                    for period in selection {
                        if(listsArray.contains(periodList(period: period)) == false && periodList(period: period) != ""){
                            listsArray.append("\(period + 1): " + periodList(period: period))
                        }
                    }
                    lists = listsArray.joined(separator: "\"") + "\""
                }
                    Text(String(lists))
                }
                
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                //trailing: EditButton() //{
                    //presentationMode.wrappedValue.dismiss()
                //})
            )
            .environment(\.editMode, .constant(EditMode.active))
        }
    }
    func periodList(period: Int) -> String {
        var nameString = ""
        for name in (driverIndex.names){
            if(name.period == period){
                nameString.append(name.name + ", ")
            }
        }
        return nameString
    }
    func createListOptions(names: String) {
        
    }
}

