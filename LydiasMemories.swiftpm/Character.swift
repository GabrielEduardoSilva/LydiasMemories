import SpriteKit

class Character: SKSpriteNode {

    init() {
        
        let texture = SKTexture(imageNamed: "Character")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        zPosition = 1
        
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = true
        physicsBody?.friction = 0 // Avoid slowing down because of the Platform
        physicsBody?.restitution = 0 // Avoid bouncing because of the Safe Barrier
        
        physicsBody?.categoryBitMask = Collision.character
        physicsBody?.collisionBitMask = Collision.platform
        physicsBody?.contactTestBitMask = Collision.projectile

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Character {
    func move(touches: Set<UITouch>) {
        for touch in touches {
            if touch.location(in: self.parent!).x > 0 { // Check where was the touch on screen: right or left
                self.physicsBody?.velocity = CGVector(dx: self.size.width * 3, dy: 0)
            } else {
                self.physicsBody?.velocity = CGVector(dx: -self.size.width * 3, dy: 0)
            }
        }
    }
    
    func hit() {
        self.run(.repeat(.sequence([.fadeAlpha(to: 0.5, duration: 0), .wait(forDuration: 0.2), .fadeAlpha(to: 1, duration: 0), .wait(forDuration: 0.2)]), count: 3))
    }
}

