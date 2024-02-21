import SpriteKit

class CollectibleMemory: SKSpriteNode {

    init() {
        
        let texture = SKTexture(imageNamed: "CollectibleMemory")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        name = "CollectibleMemory"
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        zPosition = 1
        
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.friction = 0
        
        physicsBody?.categoryBitMask = Collision.collectibleMemory
        physicsBody?.collisionBitMask = Collision.character
        physicsBody?.contactTestBitMask = Collision.character
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
