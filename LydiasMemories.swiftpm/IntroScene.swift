import SpriteKit
import AVFAudio

struct LabelConfiguration {
    let text: String
    let fontSize: CGFloat
}

class IntroScene: SKScene {
    private var labels: [LabelConfiguration] = []
    private var currentIndex = -1
    private let title = SKLabelNode(text: "Lydia's Memories")
    private let subtitle = SKLabelNode(text: "- tap to start -")
    private let label = SKLabelNode()
    private let cassetteTape = SKSpriteNode(imageNamed: "CassetteTape")
    
    // Sounds
    var brownNoise: AVAudioPlayer!
    
    public override func didMove(to view: SKView) {
        backgroundColor = .black
        self.isUserInteractionEnabled = false
        
        self.loadSounds()
        
        label.fontColor = .white
        label.fontName = "CourierPrime-Italic"
        label.numberOfLines = 2
        
        // Centering the node
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        
        label.position = CGPoint(x: frame.midX, y: frame.midY-label.frame.height/2)
        
        self.labels = [
            LabelConfiguration(text: "Music is capable of awakening memories and sensations in Alzheimer's patients", fontSize: self.size.width > 1194 ? 42 : 32),
            LabelConfiguration(text: "Help your granny Lydia recover memories with music", fontSize: self.size.width > 1194 ? 42 : 32),
            LabelConfiguration(text: "Hi granny, do you remember me?", fontSize: self.size.width > 1194 ? 42 : 32),
            LabelConfiguration(text: "It's your grandson.", fontSize: self.size.width > 1194 ? 42 : 32),
            LabelConfiguration(text: "Let's hear your favorite music!", fontSize: self.size.width > 1194 ? 42 : 32)]
        
        addChild(label)
        
        title.fontColor = .white
        title.fontName = "CourierPrime-Italic"
        title.fontSize = self.size.width > 1194 ? 112 : 86
        title.horizontalAlignmentMode = .center
        title.verticalAlignmentMode = .center
        title.position = CGPoint(x: frame.midX, y: frame.midY)
        title.alpha = 0
        addChild(title)
        
        subtitle.fontColor = .white
        subtitle.fontName = "CourierPrime-Regular"
        subtitle.fontSize = self.size.width > 1194 ? 42 : 32
        subtitle.horizontalAlignmentMode = .center
        subtitle.verticalAlignmentMode = .center
        subtitle.position = CGPoint(x: title.position.x, y: title.position.y - title.frame.height)
        subtitle.alpha = 0
        addChild(subtitle)
        
        title.run(.fadeIn(withDuration: 1))
        subtitle.run(.fadeIn(withDuration: 1)) {
            self.isUserInteractionEnabled = true
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isUserInteractionEnabled == true {
            self.isUserInteractionEnabled = false
            self.title.run(.fadeOut(withDuration: 1))
            self.subtitle.run(.fadeOut(withDuration: 1)) {
                self.brownNoise.play()
                self.brownNoise.setVolume(1, fadeDuration: 1)
                self.runIntroAnimation()
            }
        }
    }
    
    private func loadSounds() {
        self.brownNoise = loadSound(fileNamed: "brownNoise.mp3")
        self.brownNoise.numberOfLoops = -1 // Loop "forever"
        self.brownNoise.volume = 0
    }
    
    private func runIntroAnimation() {
        let changeScene = SKAction.run {
            self.transition()
        }
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        let wait = SKAction.wait(forDuration: 3)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let changeText = SKAction.run {
            // Update the text
            self.currentIndex = self.currentIndex + 1
            if self.currentIndex >= 2 {
                // Last slide
                self.label.removeAllActions()
                
                let firstLine = SKLabelNode(text: self.labels[self.currentIndex].text)
                firstLine.fontName = "CourierPrime-Italic"
                firstLine.fontSize = self.labels[self.currentIndex].fontSize
                firstLine.alpha = 0
                firstLine.horizontalAlignmentMode = .left
                firstLine.verticalAlignmentMode = .center
                firstLine.position = CGPoint(x: self.frame.midX - firstLine.frame.size.width / 2, y: self.frame.midY + firstLine.frame.size.height * 1.2)
                self.addChild(firstLine)
                firstLine.run(.sequence([fadeIn, .wait(forDuration: 1)])) {
                    
                    self.currentIndex += 1
                    
                    let secondLine = SKLabelNode(text: self.labels[self.currentIndex].text)
                    secondLine.fontName = "CourierPrime-Italic"
                    secondLine.fontSize = self.labels[self.currentIndex].fontSize
                    secondLine.alpha = 0
                    secondLine.horizontalAlignmentMode = .left
                    secondLine.verticalAlignmentMode = .center
                    secondLine.position = CGPoint(x: firstLine.position.x, y: self.frame.midY)
                    self.addChild(secondLine)
                    secondLine.run(.sequence([fadeIn, .wait(forDuration: 1)])) {
                        
                        self.currentIndex += 1
                        
                        let thirdLine = SKLabelNode(text: self.labels[self.currentIndex].text)
                        thirdLine.fontName = "CourierPrime-Italic"
                        thirdLine.fontSize = self.labels[self.currentIndex].fontSize
                        thirdLine.alpha = 0
                        thirdLine.horizontalAlignmentMode = .left
                        thirdLine.verticalAlignmentMode = .center
                        thirdLine.position = CGPoint(x: firstLine.position.x, y: self.frame.midY - thirdLine.frame.size.height * 1.2)
                        self.addChild(thirdLine)
                        
                        if self.size.width > 1194 {
                            self.cassetteTape.setScale(0.25)
                        } else {
                            self.cassetteTape.setScale(0.15)
                        }
                        self.cassetteTape.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                        self.cassetteTape.position = CGPoint(x: self.frame.midX, y: thirdLine.position.y - thirdLine.frame.size.height * 1.2 - self.cassetteTape.size.height / 2)
                        self.cassetteTape.alpha = 0
                        self.addChild(self.cassetteTape)
                        self.cassetteTape.run(.sequence([fadeIn, wait]))
                        thirdLine.run(.sequence([fadeIn, wait])) {
                            firstLine.run(fadeOut)
                            secondLine.run(fadeOut)
                            thirdLine.run(fadeOut) {
                                self.cassetteTape.run(.sequence([.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY), duration: 1), .group([.scale(to: 1, duration: 2), .fadeOut(withDuration: 2)])])) {
                                    // End of the slide, change scene
                                    self.brownNoise.setVolume(0, fadeDuration: 1)
                                    self.run(.wait(forDuration: 1)) {
                                        self.brownNoise.stop()
                                    }
                                    self.run(changeScene)
                                }
                            }
                        }
                    }
                }
            } else {
                self.label.preferredMaxLayoutWidth = self.size.width * 0.72
                self.label.text = self.labels[self.currentIndex].text
                self.label.fontSize = self.labels[self.currentIndex].fontSize
            }
        }
        
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut, changeText])
        let repeatForever = SKAction.repeatForever(sequence)
        self.label.run(repeatForever)
    }
    
    private func transition() { // Transition to the Story Mode Game Scene
        let transition = SKTransition.fade(withDuration: 1)
        let scene = StoryGameScene(size: size)
        view?.presentScene(scene, transition: transition)
    }
}
