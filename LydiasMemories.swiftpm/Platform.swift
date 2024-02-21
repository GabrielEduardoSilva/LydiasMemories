import Foundation
import SpriteKit

class Platform: SKSpriteNode {
    let wheel1 = SKSpriteNode(imageNamed: "Wheel")
    let wheel2 = SKSpriteNode(imageNamed: "Wheel")

    init() {
        
        let texture = SKTexture(imageNamed: "Platform")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        zPosition = 1
        
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.friction = 0
        
        physicsBody?.categoryBitMask = Collision.platform
        physicsBody?.collisionBitMask = Collision.character
        physicsBody?.contactTestBitMask = Collision.projectile
        
        
        
        self.wheel1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.wheel1.position = CGPoint(x: -self.size.width * 0.3415, y: self.frame.midY)
        self.wheel1.zPosition = 2
        
        self.wheel2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.wheel2.position = CGPoint(x: self.size.width * 0.3415, y: self.frame.midY)
        self.wheel2.zPosition = 2
        
        self.addChild(wheel1)
        self.addChild(wheel2)
    }
    
    func move(touches: Set<UITouch>) {
        
        for touch in touches {
            if touch.location(in: self.parent!).x > 0 { // Check where was the touch on screen: right or left
                self.wheel1.removeAction(forKey: "MovingLeft")
                self.wheel1.run(.repeatForever(.rotate(byAngle: -.pi * 2, duration: 2)), withKey: "MovingRight")
                self.wheel2.removeAction(forKey: "MovingLeft")
                self.wheel2.run(.repeatForever(.rotate(byAngle: -.pi * 2, duration: 2)), withKey: "MovingRight")
            } else {
                self.wheel1.removeAction(forKey: "MovingRight")
                self.wheel1.run(.repeatForever(.rotate(byAngle: .pi * 2, duration: 2)), withKey: "MovingLeft")
                self.wheel2.removeAction(forKey: "MovingRight")
                self.wheel2.run(.repeatForever(.rotate(byAngle: .pi * 2, duration: 2)), withKey: "MovingLeft")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
