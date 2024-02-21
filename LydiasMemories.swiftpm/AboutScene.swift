import SpriteKit

class AboutScene: SKScene {
    private let about = SKLabelNode(text: "Recently, a group of friends made a project about Alzheimer. That inspired me to create a tribute to my late grandmother, who had Alzheimer's in her final years. We always listened to music together, and as music has consistently brought me joy throughout my life, I decided to incorporate this part of myself into the game. My grandmother taught me the importance of cherishing time with our loved ones while they are still here, and that reminiscing about memories not only strengthens family bonds but also teaches us to value the present. Thank you for playing my scene!")
    private let lidiaImage = SKSpriteNode(imageNamed: "Lidia")
    private let lidiaText = SKLabelNode(text: "Lídia Barbosa")
    private let closeButton = SKLabelNode(text: "X")
    
    private let previousScene: MenuScene
    
    init(size: CGSize, previousScene: MenuScene) {
        self.previousScene = previousScene
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        backgroundColor = .white
        
        about.fontColor = .black
        about.fontName = "CourierPrime-Regular"
        about.fontSize = self.size.width > 1194 ? 28 : 20
        about.horizontalAlignmentMode = .left
        about.verticalAlignmentMode = .center
        about.preferredMaxLayoutWidth = self.size.width * 0.4
        about.numberOfLines = 0
        about.position = CGPoint(x: self.size.width * 0.06, y: self.frame.midY)
        about.alpha = 0
        addChild(about)
        
        lidiaImage.anchorPoint = CGPoint(x: 1, y: 0.5) // It makes easier to position the image
        lidiaImage.size.width = self.size.width * 0.44
        lidiaImage.size.height = self.size.height * 0.65
        lidiaImage.position = CGPoint(x: self.size.width * 0.94, y: self.frame.midY)
        lidiaImage.alpha = 0
        addChild(lidiaImage)
        
        lidiaText.fontColor = .black
        lidiaText.fontName = "CourierPrime-Italic"
        lidiaText.fontSize = self.size.width > 1194 ? 28 : 20
        lidiaText.horizontalAlignmentMode = .center
        lidiaText.verticalAlignmentMode = .top
        lidiaText.preferredMaxLayoutWidth = self.size.width * 0.4
        lidiaText.numberOfLines = 0
        lidiaText.position = CGPoint(x: lidiaImage.position.x - lidiaImage.size.width / 2, y: lidiaImage.position.y - lidiaImage.size.height / 2 - self.size.height * 0.01)
        lidiaText.alpha = 0
        addChild(lidiaText)
        
        closeButton.fontColor = .black
        closeButton.fontName = "CourierPrime-Regular"
        closeButton.fontSize = self.size.width > 1194 ? 42 : 32
        closeButton.horizontalAlignmentMode = .left
        closeButton.verticalAlignmentMode = .top
        closeButton.position = CGPoint(x: self.size.width * 0.03, y: self.size.height * 0.96)
        closeButton.alpha = 0
        addChild(closeButton)
        
        about.run(.fadeIn(withDuration: 1))
        lidiaImage.run(.fadeIn(withDuration: 1))
        lidiaText.run(.fadeIn(withDuration: 1))
        closeButton.run(.fadeIn(withDuration: 1))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if self.closeButton.contains(location) {
                transition()
            }
        }
    }
    
    private func transition() { // Transition to the Story Mode Game Scene
        let transition = SKTransition.fade(withDuration: 1)
        view?.presentScene(previousScene, transition: transition)
    }
}
