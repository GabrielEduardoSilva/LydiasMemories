import SpriteKit

class EndingScene: SKScene {
    private var labels: [LabelConfiguration] = []
    private var currentIndex = -1
    private let title = SKLabelNode()
    
    public override func didMove(to view: SKView) {
        backgroundColor = .white
        
        title.fontColor = .black
        title.fontName = "CourierPrime-Italic"
        title.numberOfLines = 2
        title.preferredMaxLayoutWidth = self.size.width * 0.74
        
        // Centering the node
        title.horizontalAlignmentMode = .center
        title.verticalAlignmentMode = .center
        
        title.position = CGPoint(x: self.frame.midX, y: self.frame.midY-title.frame.height/2)
        
        self.labels = [
            LabelConfiguration(text: "Honey, my time has already come...", fontSize: self.size.width > 1194 ? 42 : 32),
            LabelConfiguration(text: "Thanks for being with me this whole time and for making my last days better", fontSize: self.size.width > 1194 ? 42 : 32),
            LabelConfiguration(text: "I love you, my sweetheart.", fontSize: self.size.width > 1194 ? 42 : 32),
            LabelConfiguration(text: "In memory of Lídia Barbosa", fontSize: self.size.width > 1194 ? 42 : 32)]
        
        addChild(title)
        
        runEndingAnimation()
    
    }
    
    private func runEndingAnimation() {
        let changeScene = SKAction.run {
            self.transition()
        }
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        let wait = SKAction.wait(forDuration: 3)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let changeText = SKAction.run {
            // Update the text
            self.currentIndex = self.currentIndex + 1
            if self.currentIndex >= self.labels.count { // If there is no more text in the array, it will change the scene
                self.title.removeAllActions()
                // End of the slide, change scene
                self.run(changeScene)
            } else {
                self.title.text = self.labels[self.currentIndex].text
                self.title.fontSize = self.labels[self.currentIndex].fontSize
            }
        }
        
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut, changeText])
        let repeatForever = SKAction.repeatForever(sequence)
        self.title.run(repeatForever)
    }
    
    private func transition() { // Transition to the Menu Scene
        let transition = SKTransition.fade(with: .white, duration: 1)
        let scene = MenuScene(size: size)
        view?.presentScene(scene, transition: transition)
    }
}
