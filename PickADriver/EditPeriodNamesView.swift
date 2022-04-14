//
//  EditPeriodNamesView.swift
//  PickADriver
//
//  Created by Student on 4/14/22.
//

import SwiftUI

struct EditPeriodNamesView: View {
    @ObservedObject var driverIndex: DriverIndex
    var body: some View {
        Form{
            ForEach(driverIndex.periods.indices, id: \.self) { period in
                Section(header: Text("Button \(period + 1)")){
                    TextField("Title", text: periodBinding(period: period))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
            }
        }
    }
    func periodBinding(period: Int) -> Binding<String> {
        var periodBinding: Binding<String> {
            Binding {
                 driverIndex.periods[period]
            } set: {
                driverIndex.periods[period] = $0
            }
        }
        return periodBinding
    }
}


