import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = IntroScene()
        let screenSize = UIScreen.main.bounds.size
        scene.size = CGSize(width: screenSize.width, height: screenSize.height)
        scene.scaleMode = .fill
    
        return scene
    }
    
    var body: some View {
        VStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}
