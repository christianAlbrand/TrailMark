
import SwiftUI
import TrailMarkCore

@main
struct TrailMarkApp: App {
    @State private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
    }
}
