import SwiftUI

@main
struct MyApp: App {
    init() {
        // Configuring the fonts
        MyFonts.registerFonts()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
