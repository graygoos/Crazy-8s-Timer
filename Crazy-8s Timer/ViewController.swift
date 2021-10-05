//
//  ViewController.swift
//  Crazy-8s Timer
//
//  Created by Femi Aliu on 28/08/2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet var countDownLabel: UILabel!
    @IBOutlet var sessionLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    
    var countDownTime: Int = 60
    var sessionCount: Int = 1
    
    var resetTime = 0
    
    var isTimerRunning: Bool = false
    var inSession: Bool = false
    
    var timer = Timer()
    
    var audioPlayer: AVAudioPlayer!
    var selectedSoundFileName: String = ""
    let sound: String = "note1"

    override func viewDidLoad() {
        super.viewDidLoad()
        startSession(startButton)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(session), userInfo: nil, repeats: true)
    }
    
    // MARK:- Start session / Pause session
    
    @IBAction func startSession(_ sender: UIButton) {

        if self.inSession == false {
            timer.invalidate()
            isTimerRunning = false
            self.inSession = true
            self.startButton.setTitle("Start Crazy-8 Session", for: .normal)
            self.startButton.backgroundColor = .systemGreen
        } else {
            startTimer()
            self.inSession = false
            isTimerRunning = true
            self.startButton.setTitle("Pause Session", for: .normal)
            self.startButton.backgroundColor = .systemYellow
        }
    }
    
    
    @objc func session() {
        if countDownTime > 0 {
            countDownTime -= 1
        } else if sessionCount <= 7 {
            countDownTime = 60
            sessionCount += 1
            playSound()
        } else {
            timer.invalidate()
            sessionCount = 0
            startButton.setTitle("Start Crazy-8 Session", for: .normal)
            playSound()
            audioPlayer.numberOfLoops = 2
            reset()
            startButton.isEnabled = true
        }
        
        countDownLabel.text = "\(countDownTime)"
        sessionLabel.text = "\(sessionCount)"
    }
    
    // MARK:- Reset Session
    
    @IBAction func resetSession(_sender: UIButton) {
        reset()
    }
    
    @objc func reset() {
        timer.invalidate()
        countDownTime = 60
        sessionCount = 1
        countDownLabel.text = "\(countDownTime)"
        sessionLabel.text = "\(sessionCount)"
        startButton.setTitle("Start Crazy-8 Session", for: .normal)
        startButton.backgroundColor = .systemGreen
//        startSession(startButton)
        timer.invalidate()
    }


    // MARK:- PLAY SOUND
    
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

// MARK:- NOTES

// Pause timer, reset timer, toggle button title (text)/function and color✅
// plays sound when you start timer after completing session ✅ placed reset function in else clause of session()

/* Bugs to fix:
 tapping start session button twice makes countdown run faster ✅
 tapping the reset button pauses the timer, instead of restarting crazy-8s session ✅
 I have to tap the startSession button twice to get it running initially ✅
 */

/* Features to add:
 - chime beep once for each session and then beep thrice at the end of 8th session ✅
 -  Button to change 3 times: Start Crazy-8 Session, Pause Session, Resume Session
-   Fix the design, make compatible with all iPhones and iPads
-   light mode, dark mode support
 */

/*
 Include button for google form in top left for users to give list of features they'd like to see
 */

/* Architecture of project - MVC */


