//
//  SettingsView.swift
//  PickADriver
//
//  Created by Student on 2/9/22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: Settings
    @State var lengthAmount: String
    @State private var showValidToast = false
    @State private var showInvalidToast = false
    @State private var show5SecondToast = false
    var body: some View {
        Form{
            Section(header: Text("Duration"), footer: Text("Changing this value will change the duration of the selection process."))
            {
                TextField("Length in Seconds", text: $lengthAmount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(settings.instantQueue)
                    .opacity(settings.instantQueue ? 0.5 : 1)
                Button("Save")
                {
                    if(Double(lengthAmount) ?? 30.0 == 30.0 && Double(lengthAmount) != 30.0){
                        showInvalidToast = true
                    }
                    else{
                        if(Double(lengthAmount) ?? 30.0 < 5.0){
                            show5SecondToast = true
                            settings.lengthAmount = 5.0
                        }
                        else{
                            settings.lengthAmount = Double(lengthAmount) ?? 30.0
                            showValidToast = true
                        }
                    }
                }
                .foregroundColor(Color.green)
                .font(Font.headline.weight(.bold))
                .disabled(settings.instantQueue)
                .opacity(settings.instantQueue ? 0.5 : 1)
                Toggle(isOn: $settings.instantQueue, label: {Text("Instantaneous")})
            }
            Section(header: Text("Minimum amount of columns"), footer: Text("Change this value to make use of horizontal space."))
            {
                Stepper(plural(), value: $settings.minNumberOfColumns, in: 1...10)
            }
            Section(header: Text("Suspense Mode"), footer: Text("This option will make the names disappear fast initally, but slow down as it gets to the final few names."))
            {
                Toggle(isOn: $settings.exponentialFormula, label: {Text("Suspense Mode")})
            }
            Section(header: Text("Text Scaling"), footer: Text("Use this if names frequently get truncated. (Ends with ...)")) {
                Toggle(isOn: $settings.textScaling, label: {
                    Text("Shrinked Text")
                })
                NavigationLink(destination: TextAdjustmentView(settings: settings)){
                    Text("Settings")
                }
                .disabled(settings.textScaling == false)
                
            }
        }
        .toast(isPresenting: $showValidToast){
            AlertToast(displayMode: .banner(.slide), type: .complete(Color(UIColor.systemGreen)), title: "Success!", subTitle: "Length has been successfully set to \(lengthAmount)")
        }
        .toast(isPresenting: $show5SecondToast){
            AlertToast(displayMode: .banner(.slide), type: .error(Color(UIColor.systemYellow)), title: "\(lengthAmount) is below minimum length.", subTitle: "Value set to minimum (5.0)")
        }
        .toast(isPresenting: $showInvalidToast){
            AlertToast(displayMode: .banner(.slide), type: .error(Color(UIColor.systemRed)), title: "\(lengthAmount) is not a valid length.", subTitle: "Value set to default (30.0)")
        }
    }
    func plural() -> String{
        var text = "\(settings.minNumberOfColumns) Columns"
        if settings.minNumberOfColumns == 1{
            text = "1 Column"
        }
        return text
    }
}

class Settings: ObservableObject{
    @Published var lengthAmount: Double {
        didSet{
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(lengthAmount) {
            UserDefaults.standard.set(encoded, forKey: "length")
        }
        }
    }
    @Published var exponentialFormula: Bool {
        didSet{
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(exponentialFormula) {
            UserDefaults.standard.set(encoded, forKey: "exponentialFormula")
        }
        }
    }
    @Published var minNumberOfColumns: Int {
        didSet{
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(minNumberOfColumns) {
            UserDefaults.standard.set(encoded, forKey: "minNumberOfColumns")
        }
        }
    }
    @Published var instantQueue: Bool {
        didSet{
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(instantQueue) {
            UserDefaults.standard.set(encoded, forKey: "instantQueue")
        }
        }
    }
    @Published var textScaling: Bool {
        didSet{
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(textScaling) {
            UserDefaults.standard.set(encoded, forKey: "textScaling")
        }
        }
    }
    @Published var textScalingSize: CGFloat {
        didSet{
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(textScalingSize) {
            UserDefaults.standard.set(encoded, forKey: "textScalingSize")
        }
        }
        
    }
    init(){
        self.lengthAmount = 30.0
        self.exponentialFormula = false
        self.minNumberOfColumns = 1
        self.instantQueue = false
        self.textScaling = false
        self.textScalingSize = 0.5
        if let exponentialFormula = UserDefaults.standard.data(forKey: "exponentialFormula") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Bool.self, from: exponentialFormula) {
                self.exponentialFormula = decoded
                }
            }
        if let minNumberOfColumns = UserDefaults.standard.data(forKey: "minNumberOfColumns") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Int.self, from: minNumberOfColumns) {
                self.minNumberOfColumns = decoded
                }
            }
        if let lengthAmount = UserDefaults.standard.data(forKey: "length") {
            
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Double.self, from: lengthAmount) {
                self.lengthAmount = decoded
                }
            }
        if let instantQueue = UserDefaults.standard.data(forKey: "instantQueue") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Bool.self, from: instantQueue) {
                self.instantQueue = decoded
                }
            }
        if let textScaling = UserDefaults.standard.data(forKey: "textScaling") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Bool.self, from: textScaling) {
                self.textScaling = decoded
                }
            }
        if let textScalingSize = UserDefaults.standard.data(forKey: "textScalingSize") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(CGFloat.self, from: textScalingSize) {
                self.textScalingSize = decoded
                return
                }
            }
    }
}
