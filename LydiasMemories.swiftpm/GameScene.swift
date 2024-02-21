import SpriteKit
import AVFoundation
import GameplayKit

class StoryGameScene: SKScene {
    
    // Entities
    let character = Character()
    let platform = Platform()
    let enemies = SKNode()
    let projectiles = SKNode()
    let background = SKSpriteNode(imageNamed: "Background0")
    
    // HUD and Labels
    let tapOnScreen = SKSpriteNode(imageNamed: "TapOnScreen")
    let tutorialLabel = SKLabelNode()
    let CollectibleMemoriesLabel = SKLabelNode()
    
    // Logic
    var started = false
    var firstTouch = false
    var enemySpawn = false
    var collectibleMemorySpawnCounter = 0
    var collectedMemories = 0 {
        didSet {
            CollectibleMemoriesLabel.text = "\(collectedMemories)/5"
        }
    }
    var damage = 0 {
        didSet {
            if oldValue > damage { // Logic to "regenerate" the background
                background.run(.repeat(.animate(with: [background.texture!, SKTexture(imageNamed: "Background\(damage)")], timePerFrame: 0.2), count: 3))
            } else {
                background.texture = SKTexture(imageNamed: "Background\(damage)")
            }
        }
    }
    var firstMemory = true
    
    // Logic to avoid bugs on contact detection
    var detectionTime:Double = 0.0
    var startDetection = Date.now
    
    // Sounds
    var shootSound: AVAudioPlayer!
    var hitSound: AVAudioPlayer!
    var playTape: AVAudioPlayer!
    var gameplayMusic: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        self.backgroundColor = .black
        
        if !self.started {
            
            self.view?.isUserInteractionEnabled = false
            
            self.loadSounds()
            
            setCamera(scene: self)
            
            setPlatform(scene: self)
            setCharacter(scene: self)
            addChild(projectiles)
            
            tutorial()
            
            started = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Move the character by tapping the screen
        self.character.move(touches: touches)
        
        // Move the cassette tape wheels
        self.platform.move(touches: touches)
        
        // Change the scenario
        if self.firstTouch == false {
            self.changeScenario()
            self.playTape.play()
            self.gameplayMusic.play()
            self.gameplayMusic.setVolume(1, fadeDuration: 2)
            self.firstTouch = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    private func loadSounds() {
        self.shootSound = loadSound(fileNamed: "shootSound.mp3")
        self.hitSound = loadSound(fileNamed: "hitSound.mp3")
        self.playTape = loadSound(fileNamed: "playTapeSound.mp3")
        self.playTape.volume = 0.7
        self.gameplayMusic = loadSound(fileNamed: "GameplayMusic.mp3")
        self.gameplayMusic.numberOfLoops = -1 // Loop "forever"
        self.gameplayMusic.volume = 0 // Volume 0 for fade in effect
    }
    
    private func setCamera(scene: SKScene) {
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: 0, y: scene.size.height/2)
        scene.addChild(cameraNode)
        scene.camera = cameraNode
    }
    
    private func setPlatform(scene: SKScene) {
        if self.size.width > 1194 {
            self.platform.setScale(1)
            self.platform.wheel1.setScale(1)
            self.platform.wheel2.setScale(1)
            self.platform.position = CGPoint(x: 0, y: (self.platform.size.height / 2) + (self.size.height * 0.02))
            
        } else {
            self.platform.setScale(0.75)
            self.platform.wheel1.setScale(0.75)
            self.platform.wheel2.setScale(0.75)
            self.platform.position = CGPoint(x: 0, y: (self.platform.size.height / 2) + (self.size.height * 0.02))
        }
        
        scene.addChild(platform)
    }
    
    private func setCharacter(scene: SKScene) {
        if self.size.width > 1194 {
            self.character.setScale(1)
        } else {
            self.character.setScale(0.75)
        }
        self.character.position = CGPoint(x: 0, y: self.platform.position.y + self.platform.size.height/2 + self.character.size.height/2)
        
        // Configuring constraints so the character don't fall of the platform
        self.character.constraints = [
            SKConstraint.positionX(SKRange(lowerLimit: -self.platform.size.width / 2 + self.character.size.width / 2, upperLimit: self.platform.size.width / 2 - self.character.size.width / 2))
        ]
        
        scene.addChild(character)
    }
    
    func setCollectibleMemoryLabel(scene: SKScene) {
        let collectibleMemoryForLabel = CollectibleMemory()
        
        self.CollectibleMemoriesLabel.text = "\(self.collectedMemories)/5"
        self.CollectibleMemoriesLabel.fontName = "CourierPrime-Regular"
        self.CollectibleMemoriesLabel.fontColor = .black
        self.CollectibleMemoriesLabel.fontSize = 80
        
        self.CollectibleMemoriesLabel.position = CGPoint(x: (self.size.width * 0.80) / 2, y: self.size.height * 0.90)
        self.CollectibleMemoriesLabel.verticalAlignmentMode = .center
        self.CollectibleMemoriesLabel.horizontalAlignmentMode = .center
        
        self.CollectibleMemoriesLabel.addChild(collectibleMemoryForLabel)
        
        collectibleMemoryForLabel.position = CGPoint(x: Int(-self.CollectibleMemoriesLabel.frame.size.width) / 2 - Int(collectibleMemoryForLabel.size.width) / 2, y: 0)
        
        self.addChild(self.CollectibleMemoriesLabel)
        
    }
    
    private func tutorial() {
        // Scene's inicial configuration
        self.platform.alpha = 0.1
        self.tutorialLabel.zPosition = 2
        self.addChild(tutorialLabel)
        
        // Tutorial's steps
        let secondStep = SKAction.run {
            // Tap on the screen image
            if self.size.width > 1194 {
                self.tapOnScreen.setScale(1)
            } else {
                self.tapOnScreen.setScale(0.75)
            }
            self.tapOnScreen.position = CGPoint(x: 0, y: self.frame.midY)
            self.tapOnScreen.alpha = 0
            self.addChild(self.tapOnScreen)
            self.tapOnScreen.run(.sequence([.fadeAlpha(to: 0.3, duration: 1), .wait(forDuration: 3), .fadeOut(withDuration: 1)]))
            
            // Label configuration
            self.tutorialLabel.text = "Tap on the screen to play the cassette tape"
            self.tutorialLabel.fontName = "CourierPrime-Regular"
            self.tutorialLabel.fontSize = self.size.width > 1194 ? 42 : 32
            self.tutorialLabel.position = CGPoint(x: self.platform.frame.midX, y: self.character.position.y + 110 + self.character.size.height / 2)
            
            // Label animation
            self.tutorialLabel.run(.sequence([ .fadeIn(withDuration: 1), .wait(forDuration: 3), .fadeOut(withDuration: 1)])) {
                self.tutorialSecondPart()
            }
        }
        let firstStep = SKAction.run {
            // Label configuration
            self.tutorialLabel.text = "This is a memory"
            self.tutorialLabel.fontName = "CourierPrime-Regular"
            self.tutorialLabel.fontSize = self.size.width > 1194 ? 42 : 32
            self.tutorialLabel.position = CGPoint(x: self.platform.frame.midX, y: self.character.position.y + self.character.frame.height / 2 + 110)
            
            // Label animation
            self.tutorialLabel.run(.sequence([.wait(forDuration: 3), .fadeOut(withDuration: 1)])) {
                // Scene configuration
                self.view?.isUserInteractionEnabled = true
                
                // Next step
                self.run(secondStep)
            }
        }
        
        self.run(firstStep)
        
    }
    
    private func tutorialSecondPart() {
        let secondStep = SKAction.run {
            self.tutorialLabel.text = "The alzheimer will try to shoot you. Dodge!"
            self.tutorialLabel.fontName = "CourierPrime-Regular"
            self.tutorialLabel.fontSize = self.size.width > 1194 ? 42 : 32
            
            self.tutorialLabel.run(.sequence([ .fadeIn(withDuration: 1), .wait(forDuration: 3), .fadeOut(withDuration: 1)]))
        }
        let firstStep = SKAction.run {
            // Label configuration
            self.tutorialLabel.text = "Protect Lydia's memory from the alzheimer's forgetfulnes"
            self.tutorialLabel.fontName = "CourierPrime-Regular"
            self.tutorialLabel.fontSize = self.size.width > 1194 ? 38 : 32
            self.tutorialLabel.position = CGPoint(x: self.platform.frame.midX, y: self.character.position.y + 110 + self.character.size.height / 2)
            
            // Label animation
            self.tutorialLabel.run(.sequence([.fadeIn(withDuration: 1), .wait(forDuration: 3), .fadeOut(withDuration: 1)])) {
                self.addChild(self.enemies)
                self.enemySpawn = true
                // Next step
                self.run(secondStep)
            }
        }
        
        self.run(firstStep)
    }
    
    private func changeScenario() {
        self.run(SKAction.run {
            // Platform
            self.platform.run(.fadeAlpha(to: 1, duration: 1))
            
            // Background
            let whiteBackground = SKShapeNode(circleOfRadius: 10)
            whiteBackground.fillColor = .white
            whiteBackground.zPosition = -2
            whiteBackground.alpha = 0.1
            self.character.addChild(whiteBackground)
            whiteBackground.run(.scale(by: 200, duration: 2))
            whiteBackground.run(.fadeAlpha(to: 1, duration: 2)) {
                self.backgroundColor = .white
                
                if self.size.width > 1194 {
                    self.background.setScale(1)
                } else {
                    self.background.setScale(0.75)
                }
                self.background.position = CGPoint(x: 0, y: self.frame.midY)
                self.background.zPosition = -1
                self.addChild(self.background)
                
                // Changing whiteBackground's parent so the Character's hit animation won't bug
                whiteBackground.removeFromParent()
                self.background.addChild(whiteBackground)
            }
            
            // Label
            self.tutorialLabel.fontColor = .black
            
            // Tap on screen image
            self.tapOnScreen.colorBlendFactor = 1
            self.tapOnScreen.color = .black
        })
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // === ENEMIES LOGIC ===
        
        // Logic to add enemies
        let random:Int = Int.random(in: 1...10)
        if random == 1 && self.enemySpawn && self.enemies.children.count < 4 {
            let enemy = Enemy()
            
            // Configuring the size
            if self.size.width > 1194 {
                enemy.setScale(1)
            } else {
                enemy.setScale(0.75)
            }
            
            enemy.position = CGPoint(x: Int.random(in: Int(-(self.size.height/2))...Int((self.size.height/2))), y: Int(self.size.height) + 200)
            
            self.enemies.addChild(enemy)
            enemy.getIn()
        }
        
        // Logic to all enemies aim
        for enemy in enemies.children {
            if let enemyNode = enemy as? Enemy {
                enemyNode.aim(characterPosition: character.position)
            }
        }
        
        // Logic to all enemies shoot
        for enemy in enemies.children {
            let random:Int = Int.random(in: 1...60)
            if random == 1 {
                if let enemyNode = enemy as? Enemy {
                    if !enemyNode.hasActions() && self.character.physicsBody?.velocity != .zero {
                        enemyNode.shoot(characterPosition: character.position)
                        self.shootSound.play()
                    }
                }
            }
        }
        
        // Logic to delete enemies that run out of ammo
        for enemy in enemies.children {
            if let enemyNode = enemy as? Enemy {
                if enemyNode.ammo <= 0 && enemyNode.children.count <= 1 && !enemyNode.hasActions() && self.character.physicsBody?.velocity != .zero {
                    enemyNode.getOut()
                }
            }
        }
        
        // Logic to delete enemies out of the scene
        for enemy in enemies.children {
            if let enemyNode = enemy as? Enemy {
                if Int(enemyNode.position.y) >= Int(self.scene!.size.height / 0.8) && enemyNode.ammo <= 0 {
                    enemyNode.removeFromParent()
                }
            }
        }
        
        // Logic to delete projectiles out of the scene and add Collectible Memories
        for projectile in projectiles.children {
            if projectile.position.y < 0 {
                projectile.removeFromParent()
                self.collectibleMemorySpawnCounter += 1
                if self.collectibleMemorySpawnCounter == 9 {
                    spawnMemory()
                }
            }
        }
    }
}

extension StoryGameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // Code to detect only 1 contact. Without it, the same contact is detected 2 times.
        detectionTime = Date.now.timeIntervalSince(startDetection)
        
        // Logic for contact between Character and Projectile
        if contact.bodyA.categoryBitMask == Collision.projectile && contact.bodyB.categoryBitMask == Collision.character {
            // Code to detect only 1 contact. Without it, the same contact is detected 2 times.
            if detectionTime < 0.55 { return }
            startDetection = Date.now
            
            print("Contact with the character")
            
            if self.damage < 7 {
                self.damage += 1
            }
            self.camera?.run(.shake(initialPosition: self.camera!.position, duration: 0.3))
            self.character.hit()
            self.hitSound.play()
            
        } else if contact.bodyA.categoryBitMask == Collision.character && contact.bodyB.categoryBitMask == Collision.projectile {
            // Code to detect only 1 contact. Without it, the same contact is detected 2 times.
            if detectionTime < 0.55 { return }
            startDetection = Date.now
            
            print("Contact with the character")
            
            if self.damage < 7 {
                self.damage += 1
            }
            self.camera?.run(.shake(initialPosition: self.camera!.position, duration: 0.3))
            self.character.hit()
            self.hitSound.play()
        }
        
        // Logic for contact between Character and Collectible Memory
        if contact.bodyA.categoryBitMask == Collision.character && contact.bodyB.categoryBitMask == Collision.collectibleMemory {
            // Code to detect only 1 contact. Without it, the same contact is detected 2 times.
            if detectionTime < 0.55 { return }
            startDetection = Date.now
            
            contact.bodyB.node?.removeFromParent()
            print("Collected memory")
            collectibleMemorySpawnCounter = 0
            collectedMemories += 1
            transitionToMemory()
        } else if contact.bodyA.categoryBitMask == Collision.collectibleMemory && contact.bodyB.categoryBitMask == Collision.character {
            // Code to detect only 1 contact. Without it, the same contact is detected 2 times.
            if detectionTime < 0.55 { return }
            startDetection = Date.now
            
            contact.bodyA.node?.removeFromParent()
            print("Collected memory")
            collectibleMemorySpawnCounter = 0
            collectedMemories += 1
            transitionToMemory()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}

extension StoryGameScene {
    private func transitionToMemory() { // Transition to the Memory Scene
        let transition = SKTransition.fade(withDuration: 2)
        let scene = MemoryScene(size: size, previousScene: self, collectedMemories: self.collectedMemories)
        view?.presentScene(scene, transition: transition)
    }
}

// Collectible Memory
extension StoryGameScene {
    private func collectibleMemoryTutorial() {
        let transition = SKTransition.crossFade(withDuration: 0.5)
        let scene = CollectibleMemoryScene(size: size, previousScene: self, collectibleMemory: self.childNode(withName: "CollectibleMemory")! as! CollectibleMemory)
        view?.presentScene(scene, transition: transition)
    }
    
    private func spawnMemory() {
        let collectibleMemory = CollectibleMemory()
        
        if self.character.position.x >= 0 { // If Character on right side -> spawn Collectible Memory on Character's left
            let xLeftPosition = CGFloat.random(in: -self.platform.size.width/2...(self.character.position.x - self.character.size.width/2 - collectibleMemory.size.width))
            collectibleMemory.position = CGPoint(x: xLeftPosition, y: self.character.position.y)
        } else { // If Character on left side -> spawn Collectible Memory on Character's right
            let xRightPosition = CGFloat.random(in: (self.character.position.x + self.character.size.width/2 + collectibleMemory.size.width)...self.platform.size.width/2)
            collectibleMemory.position = CGPoint(x: xRightPosition, y: self.character.position.y)
        }
        
        self.addChild(collectibleMemory)
        if self.firstMemory {
            self.collectibleMemoryTutorial()
            self.firstMemory = false
        }
    }
}

// Extension to create an action to shake the camera
extension SKAction {
     class func shake(initialPosition:CGPoint, duration:Float, amplitudeX:CGFloat = 30, amplitudeY:CGFloat = 7) -> SKAction {
         // Setting the initial position
         let startingX = initialPosition.x
         let startingY = initialPosition.y
         
         // Setting the number of shakes
         let numberOfShakes = duration / 0.015
         
         // Shaking
         var actionsArray:[SKAction] = []
         for _ in 1...Int(numberOfShakes) {
             let newXPos = startingX + CGFloat.random(in: 0...amplitudeX) - CGFloat(amplitudeX / 2)
             let newYPos = startingY + CGFloat.random(in: 0...amplitudeY) - CGFloat(amplitudeY / 2)
             actionsArray.append(SKAction.move(to: CGPointMake(newXPos, newYPos), duration: 0.015))
         }
         actionsArray.append(SKAction.move(to: initialPosition, duration: 0.015))
         return SKAction.sequence(actionsArray)
     }
 }
