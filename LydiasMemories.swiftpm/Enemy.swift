import SpriteKit

class Enemy: SKSpriteNode {
    var ammo: Int

    init() {
        
        let texture = SKTexture(imageNamed: "Enemy")
        
        
        
        // Configuring ammo
        self.ammo = Int.random(in: 1...5)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = "Enemy"
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Attack functions
extension Enemy {
    func aim(characterPosition: CGPoint) {
        let offX = characterPosition.x - self.position.x
        let offY = self.position.y - characterPosition.y
        let angle = atan(abs(offX) / offY)
        if characterPosition.x > self.position.x {
            self.zRotation = angle
        } else if characterPosition.x < self.position.x {
            self.zRotation = -angle
        }
    }

    func shoot(characterPosition: CGPoint) {
        if ammo > 0 && self.position.y <= self.scene!.size.height {
            // Defining projectile
            let projectileSprite = SKSpriteNode(imageNamed: "Projectile") // Projectile's sprite
            projectileSprite.name = "ProjectileSprite"
            projectileSprite.position = CGPoint(x: 0, y: -30)
            projectileSprite.zPosition = 1
            
            // Configuring the projectile physics
            projectileSprite.physicsBody = SKPhysicsBody(texture: projectileSprite.texture!, size: projectileSprite.texture!.size())
            projectileSprite.physicsBody?.affectedByGravity = false
            projectileSprite.physicsBody?.isDynamic = true
            
            // Configuring the projectile's category, collision and contact
            projectileSprite.physicsBody?.categoryBitMask = Collision.projectile
            projectileSprite.physicsBody?.collisionBitMask = 0
            projectileSprite.physicsBody?.contactTestBitMask = Collision.character
            
            // Positioning the projectile according to the enemy's position
            projectileSprite.position = CGPoint(x: self.position.x, y: self.position.y)
            projectileSprite.zRotation = self.zRotation
            if let scene = self.parent!.parent! as? StoryGameScene {
                scene.projectiles.addChild(projectileSprite)
            }

            // Configure the vector Enemy -> Character
            let dx = characterPosition.x - self.position.x
            let dy = characterPosition.y - self.position.y
            let magnetude = sqrt(dx * dx + dy * dy)
            
            projectileSprite.physicsBody?.velocity = CGVector(dx: 500 * dx/magnetude, dy: 500 * dy/magnetude) // Shoot towards the Character
            
            self.ammo -= 1 // -1 ammo
        }
    }
}

// Moving functions
extension Enemy {
    func getIn() {
        self.run(.move(to: CGPoint(x: Int.random(in: Int(-(self.scene!.size.width/2 - 100))...Int((self.scene!.size.width/2 - 100))), y: Int.random(in: Int(self.scene!.size.height / 1.75)...Int(self.scene!.size.height / 1.5))), duration: 3), withKey: "getting in")
    }
    func getOut() {
        self.run(.move(to: CGPoint(x: Int.random(in: Int(-(self.scene!.size.width/2 - 100))...Int((self.scene!.size.width/2 - 100))), y: Int(self.scene!.size.height / 0.8)), duration: 2))
    }
}
