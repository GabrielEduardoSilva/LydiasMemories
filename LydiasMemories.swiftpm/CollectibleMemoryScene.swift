import SpriteKit

class CollectibleMemoryScene: SKScene {

    private let previousScene: StoryGameScene
    
    private let platform = Platform()
    private let character = Character()
    private let collectibleMemory = CollectibleMemory()
    
    private let tutorialLabel = SKLabelNode()
    
    init(size: CGSize, previousScene: StoryGameScene, collectibleMemory: CollectibleMemory) {
        self.previousScene = previousScene
        
        // Positioning
        self.platform.position = previousScene.platform.position
        self.character.position = previousScene.character.position
        self.collectibleMemory.position = collectibleMemory.position
        
        super.init(size: size)
        
        // Resizing
        if self.size.width > 1194 {
            self.platform.setScale(1)
            self.platform.wheel1.setScale(1)
            self.platform.wheel2.setScale(1)
            self.character.setScale(1)
        } else {
            self.platform.setScale(0.75)
            self.platform.wheel1.setScale(0.75)
            self.platform.wheel2.setScale(0.75)
            self.character.setScale(0.75)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        self.backgroundColor = .white
        self.setCamera(scene: self)
        
        self.addChild(platform)
        self.addChild(character)
        self.addChild(collectibleMemory)
        
        self.setTutorialLabel(scene: self)
        
        self.camera?.run(.group([.scale(to: 0.5, duration: 0.5), .move(to: CGPoint(x: collectibleMemory.position.x, y: collectibleMemory.position.y + collectibleMemory.size.height / 2), duration: 0.5)]))
        
        self.run(.wait(forDuration: 5)) {
            self.tutorialLabel.run(.fadeOut(withDuration: 1))
            self.camera?.run(.group([.scale(to: 1, duration: 1), .move(to: CGPoint(x: 0, y: self.size.height/2), duration: 1)])) {
                self.transitionToStoryGameScene()
            }
        }
    
    }
    
    private func setCamera(scene: SKScene) {
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: 0, y: scene.size.height/2)
        scene.addChild(cameraNode)
        scene.camera = cameraNode
    }
    
    private func setTutorialLabel(scene: SKScene) {
        self.tutorialLabel.text = "This note can awake a memory. Collect it!"
        self.tutorialLabel.fontName = "CourierPrime-Regular"
        self.tutorialLabel.fontSize = self.size.width > 1194 ? 21 : 16
        self.tutorialLabel.fontColor = .black
        self.tutorialLabel.position = CGPoint(x: self.collectibleMemory.position.x, y: self.collectibleMemory.position.y + self.collectibleMemory.size.height + 20)
        scene.addChild(tutorialLabel)
    }
}

extension CollectibleMemoryScene {
    private func transitionToStoryGameScene() { // Transition to the Story Game Scene
        let transition = SKTransition.crossFade(withDuration: 0.5)
        let scene = previousScene
        self.previousScene.setCollectibleMemoryLabel(scene: self.previousScene)
        view?.presentScene(scene, transition: transition)
    }
}
