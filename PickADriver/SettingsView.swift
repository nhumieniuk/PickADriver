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
    var body: some View {
        Form{
            Section(header: Text("Duration"), footer: Text("Changing this value will change the duration of the selection process."))
            {
                TextField("Length in Seconds", text: $lengthAmount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Save")
                {
                    if(Double(lengthAmount) ?? 30.0 == 30.0 && Double(lengthAmount) != 30.0){
                        showInvalidToast = true
                    }
                    else{
                        showValidToast = true
                    }
                    settings.lengthAmount = Double(lengthAmount) ?? 30.0
                    print(settings.lengthAmount)
                }
                .foregroundColor(Color.green)
                .font(Font.headline.weight(.bold))
            }
            Section(header: Text("Minimum amount of columns"), footer: Text("Change this value to make use of horizontal space."))
            {
                Stepper(plural(), value: $settings.minNumberOfColumns, in: 1...10)
            }
            Section(header: Text("Exponential Formula"), footer: Text("Selecting this will make the names disappear exponentially, if turned off it will disappear linearly."))
            {
                Toggle(isOn: $settings.exponentialFormula, label: {Text("Exponential Formula")})
            }
            Section(header: Text("Dark Mode"))
            {
                Toggle(isOn: $settings.darkMode, label: {Text("Dark mode")})
            }
        }
        .toast(isPresenting: $showValidToast){
            AlertToast(displayMode: .banner(.slide), type: .complete(Color(UIColor.systemGreen)), title: "Length has been successfully set to \(lengthAmount)")
        }
        .toast(isPresenting: $showInvalidToast){
            AlertToast(displayMode: .banner(.slide), type: .error(Color(UIColor.systemYellow)), title: "\(lengthAmount) is not a valid length. Value set to 30.0.")
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
    @Published var darkMode: Bool {
        didSet{
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(darkMode) {
            UserDefaults.standard.set(encoded, forKey: "darkMode")
        }
        }
    }
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
    init(){
        self.darkMode = true
        self.lengthAmount = 30.0
        self.exponentialFormula = false
        self.minNumberOfColumns = 1
        if let darkMode = UserDefaults.standard.data(forKey: "darkMode") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Bool.self, from: darkMode) {
                self.darkMode = decoded
                }
            }
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
                return
                }
            }
    }
}
