//
//  DriverIndex.swift
//  PickADriver
//
//  Created by Student on 2/2/22.
//

import Foundation

class DriverIndex: ObservableObject {
    @Published var names: [Name] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(names) {
                UserDefaults.standard.set(encoded, forKey: "Pick a Driver:  Period")
            }
        }
    }
    @Published var periods: [String] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(periods) {
                UserDefaults.standard.set(encoded, forKey: "periodNames")
            }
        }
    }
    @Published var reset: Bool
    @Published var selectingQueue: Bool
    init() {
        reset = true
        selectingQueue = false
        periods = ["Period 1", "Period 2", "Period 3", "Period 4", "Period 5", "Period 6", "Period 7", "Period 8"]
        if let periods = UserDefaults.standard.data(forKey: "periodNames") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([String].self, from: periods) {
                self.periods = decoded
            }
        }
        if let names = UserDefaults.standard.data(forKey: "Pick a Driver:  Period") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Name].self, from: names) {
                self.names = decoded
                return
            }
        }
        names = []
    }
}

 struct Name: Identifiable, Codable, Hashable {
    var period = Int()
    var id = UUID()
    var name = String()
    var faded = Bool()
    var invisible = Bool()
}

