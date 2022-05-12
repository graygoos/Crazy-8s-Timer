//
//  PlaySound.swift
//  Crazy-8s Timer
//
//  Created by Femi Aliu on 05/05/2022.
//

import UIKit
import AVFAudio

extension ViewController : AVAudioPlayerDelegate {
    
    // MARK: Play Sound
    
    func playSound() {
        let soundURL = Bundle.main.url(forResource: selectedSoundFileName, withExtension: "wav")

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }

        audioPlayer.play()
    }
}
