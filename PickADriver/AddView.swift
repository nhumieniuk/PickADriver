//
//  AddView.swift
//  PickADriver
//
//  Created by Student on 2/2/22.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var driverIndex: DriverIndex
    @ObservedObject var settings: Settings
    @State private var name = ""
    let period: Int
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
            }
            .navigationBarTitle("Add New Student")
            .navigationBarItems(trailing: Button("Save") {
                let finalName = Name(period: period, id: UUID(), name: name)
                print(period)
                print(name)
                if finalName.name != "" {
                    driverIndex.names.append(finalName)
                }
                presentationMode.wrappedValue.dismiss()
            })
        }
        .preferredColorScheme(settings.darkMode ? .dark : .light)
    }
}

