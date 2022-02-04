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
    init() {
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

