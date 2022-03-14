//
//  TextAdjustmentView.swift
//  PickADriver
//
//  Created by Student on 3/11/22.
//

import SwiftUI



struct TextAdjustmentView: View {
    @ObservedObject var settings: Settings
    @State private var scaling = 1.0
    @State private var isEditing = false
    @State var columns = [GridItem(.flexible())]
    @State var numberOfColumns = 1
    var body: some View {
        Spacer()
        VStack{
        LazyVGrid(columns: columns, spacing: 8){
            ForEach(columns.indices, id: \.self) { index in
                    Text("Hubert Blaine Wolfeschlegelsteinhausenbergerdorff Sr.")
                        .minimumScaleFactor(settings.textScalingSize)
                        .lineLimit(1)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
                        .background(Color(UIColor.secondarySystemBackground))
                        .foregroundColor(Color(UIColor.label))
                        .cornerRadius(20)
            }
        }
        .padding(8)
        }
        Spacer()
        VStack {
            Text("Minimum allowed size")
            Slider(value: $settings.textScalingSize, in: 0.01...1, step: 0.01,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            )
            Text("\(settings.textScalingSize, specifier: "%.2f")")
                .foregroundColor(isEditing ? .green : .blue)
            Stepper("Columns", value: $numberOfColumns, in: 1...10){ _ in
                if(numberOfColumns > columns.count){
                    columns.append(GridItem(.flexible()))
                }
                else if (numberOfColumns < columns.count){
                    columns.removeLast()
                }
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .padding(8)
        
    }
}

struct TextAdjustmentView_Previews: PreviewProvider {
    static var previews: some View {
        TextAdjustmentView(settings: Settings())
    }
}
