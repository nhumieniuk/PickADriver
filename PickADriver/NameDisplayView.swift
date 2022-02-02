//
//  NameDisplayView.swift
//  PickADriver
//
//  Created by Student on 2/2/22.
//

import SwiftUI

struct NameDisplayView: View {
    @ObservedObject var driverIndex: DriverIndex
    @State private var faded = false
    let period: Int
    var body: some View {
        ForEach(driverIndex.names, id: \.self) { student in
            HStack{
            if(student.period == period){
                    VStack{
                        CustomTextView(text: student.name)
                        //Text(student.name)
                          //  .opacity(faded ? 0.2 : 1)
                    }
                }
            }
        }
    }
    func removeName(){
        //remove Text from ForEach driverIndex
    }
}
    


    
extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}



struct CustomTextView: View {
    @State private var faded = false
    let text: String
    var body: some View {
        Text(text)
            .padding()
            .onTapGesture {
                faded.toggle()
            }
            .opacity(faded ? 0.2 : 1)
    }
}
