import AVFoundation
import SpriteKit

func loadSound(fileNamed: String) -> AVAudioPlayer {
    let path = Bundle.main.path(forResource: fileNamed, ofType: nil)!
    let url = URL(fileURLWithPath: path)
    var audioPlayer = AVAudioPlayer()
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
    } catch {}
    
    return audioPlayer
}


