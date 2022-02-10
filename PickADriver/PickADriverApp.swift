

import SwiftUI

@main
struct PickADriverApp: App {
    @ObservedObject var driverIndex = DriverIndex()
    @ObservedObject var settings = Settings()
    var body: some Scene {
        WindowGroup {
            ContentView(driverIndex: driverIndex, settings: settings)
        }
    }
}
