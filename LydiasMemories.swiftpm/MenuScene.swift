import SpriteKit
import AVFAudio

class MenuScene: SKScene {
    private let title = SKLabelNode(text: "Lydia's Memories")
    private let playAgain = SKLabelNode(text: "- Play Again -")
    private let about = SKLabelNode(text: "- About -")
    
    // Logic
    private var loaded = false
    
    // Sounds
    var menuMusic: AVAudioPlayer!
    
    public override func didMove(to view: SKView) {
        backgroundColor = .white
        if self.loaded == false {
            self.loadSounds()
            self.menuMusic.play()
            self.menuMusic.setVolume(0.7, fadeDuration: 2)
            self.loaded = true
            
            title.fontColor = .black
            title.fontName = "CourierPrime-Italic"
            title.fontSize = self.size.width > 1194 ? 112 : 86
            title.horizontalAlignmentMode = .center
            title.verticalAlignmentMode = .center
            title.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            title.alpha = 0
            addChild(title)
            
            playAgain.fontColor = .black
            playAgain.fontName = "CourierPrime-Regular"
            playAgain.fontSize = self.size.width > 1194 ? 42 : 32
            playAgain.horizontalAlignmentMode = .center
            playAgain.verticalAlignmentMode = .center
            playAgain.position = CGPoint(x: self.frame.midX, y: title.position.y - title.frame.height)
            playAgain.alpha = 0
            addChild(playAgain)
            
            about.fontColor = .black
            about.fontName = "CourierPrime-Regular"
            about.fontSize = self.size.width > 1194 ? 42 : 32
            about.horizontalAlignmentMode = .center
            about.verticalAlignmentMode = .center
            about.position = CGPoint(x: self.frame.midX, y: playAgain.position.y - playAgain.frame.height * 1.5)
            about.alpha = 0
            addChild(about)
        }
        
        title.run(.fadeIn(withDuration: 1))
        playAgain.run(.fadeIn(withDuration: 1))
        about.run(.fadeIn(withDuration: 1))
    }
    
    private func loadSounds() {
        self.menuMusic = loadSound(fileNamed: "EndingMusic.mp3")
        self.menuMusic.numberOfLoops = -1 // Loop "forever"
        self.menuMusic.volume = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if self.playAgain.contains(location) {
                title.run(.fadeOut(withDuration: 1))
                playAgain.run(.fadeOut(withDuration: 1))
                about.run(.fadeOut(withDuration: 1)) {
                    self.transition(scene: StoryGameScene(size: self.size))
                }
            }
            if self.about.contains(location) {
                title.run(.fadeOut(withDuration: 1))
                playAgain.run(.fadeOut(withDuration: 1))
                about.run(.fadeOut(withDuration: 1)) {
                    self.transition(scene: AboutScene(size: self.size, previousScene: self))
                }
            }
        }
    }
    
    private func transition(scene: SKScene) { // Transition to other scenes
        let transition = SKTransition.fade(withDuration: 1)
        view?.presentScene(scene, transition: transition)
    }
}
