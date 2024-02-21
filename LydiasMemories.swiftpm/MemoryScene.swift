import SpriteKit
import GameplayKit

class MemoryScene: SKScene {
    
    private let memoryImageNode: SKSpriteNode
    
    private var labels: [LabelConfiguration] = []
    private let memoryText = SKLabelNode()
    
    private let previousScene: StoryGameScene
    
    private let collectedMemories: Int
    
    init(size: CGSize, previousScene: StoryGameScene, collectedMemories: Int) {
        self.memoryImageNode = SKSpriteNode(imageNamed: "Memory\(collectedMemories)")
        self.previousScene = previousScene
        self.collectedMemories = collectedMemories
        
        super.init(size: size)
            
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .white
        
        self.labels = [
            LabelConfiguration(text: "Granny, do you remember when you sang me to sleep?", fontSize: self.size.width > 1194 ? 42 : 32),
            LabelConfiguration(text: "Granny, do you remember when you used to swing me on the swing? It was so fun!", fontSize: self.size.width > 1194 ? 42 : 32),
            LabelConfiguration(text: "Granny, could you make me more fried dumplings? I love them!", fontSize: self.size.width > 1194 ? 42 : 32),
            LabelConfiguration(text: "Let's watch your favorite TV show granny!", fontSize: self.size.width > 1194 ? 42 : 32),
            LabelConfiguration(text: "I love you granny!", fontSize: self.size.width > 1194 ? 42 : 32)]
        
        setMemoryImage()
        setMemoryText()
        if self.previousScene.collectedMemories == 5 {
            self.run(.wait(forDuration: 3)) {
                self.previousScene.gameplayMusic.setVolume(0, fadeDuration: 2)
            }
        }
        goBack()
    }
    
    private func setMemoryImage() {
        self.memoryImageNode.anchorPoint = CGPoint(x: 0.5, y: 1) // It makes easier to position the image
        self.memoryImageNode.size.width = self.size.width * 0.90
        self.memoryImageNode.size.height = self.size.height * 0.74
        self.memoryImageNode.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.94)
        addChild(memoryImageNode)
    }
    
    private func setMemoryText() {
        self.memoryText.text = self.labels[self.collectedMemories - 1].text
        self.memoryText.fontColor = .black
        self.memoryText.fontName = "CourierPrime-Italic"
        self.memoryText.fontSize = self.labels[self.collectedMemories - 1].fontSize
        self.memoryText.numberOfLines = 2
        self.memoryText.preferredMaxLayoutWidth = self.size.width * 0.90
        
        // Changing the node's anchor to make it easier to position the text
        self.memoryText.horizontalAlignmentMode = .center
        self.memoryText.verticalAlignmentMode = .top
        
        self.memoryText.position = CGPoint(x: self.frame.midX, y: self.memoryImageNode.position.y - self.memoryImageNode.size.height - self.size.height * 0.01)
        addChild(memoryText)
    }
}

// Transitions
extension MemoryScene {
    private func goBack() {
        self.run(.wait(forDuration: 5)) {
            if self.previousScene.collectedMemories == 5 {
                self.transitionToEndingScene()
            } else {
                if self.previousScene.damage > 0 {
                    self.previousScene.damage -= 1
                }
                self.transitionToStoryGameScene()
            }
        }
    }
    private func transitionToStoryGameScene() { // Transition to the Story Game Scene
        let transition = SKTransition.fade(withDuration: 1)
        let scene = previousScene
        view?.presentScene(scene, transition: transition)
    }
    private func transitionToEndingScene() { // Transition to the Ending Scene
        let transition = SKTransition.fade(withDuration: 1)
        let scene = EndingScene(size: size)
        view?.presentScene(scene, transition: transition)
    }
}


