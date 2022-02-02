

import SwiftUI

@main
struct PickADriverApp: App {
    @ObservedObject var driverIndex = DriverIndex()
    var body: some Scene {
        WindowGroup {
            ContentView(driverIndex: driverIndex)
        }
    }
}
