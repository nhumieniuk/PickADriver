//
//  AddView.swift
//  PickADriver
//
//  Created by Student on 2/2/22.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var driverIndex: DriverIndex
    @Environment(\.colorScheme) var darkMode
    @State private var name = ""
    let period: Int
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("Add multiple names by seperating them with a comma.")){
                    TextField("Name(s)", text: $name)
                }
            }
            .navigationBarTitle("Add New Name")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    var names = name.components(separatedBy: String(","))
                    for index in names.indices {
                        if(names[index].prefix(1) == " "){
                            names[index].removeFirst()
                        }
                        let name = Name(period: period, id: UUID(), name: names[index])
                        if names[index] != "" {
                            driverIndex.names.append(name)
                            print("added \(name.name)")
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                })
        }
    }
}

