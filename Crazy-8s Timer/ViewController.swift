//
//  ViewController.swift
//  Crazy-8s Timer
//
//  Created by Femi Aliu on 28/08/2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
//    @IBOutlet var countDownLabel: UILabel!
//    @IBOutlet var sessionLabel: UILabel!
//    @IBOutlet var startButton: UIButton!
//    @IBOutlet var resetButton: UIButton!
    
    let sessionButton = UIButton()
    let resetSessionButton = UIButton()
    
    var countDownTime: Int = 60
    var sessionCount: Int = 1
    
    var resetTime = 0
    
    var isTimerRunning: Bool = false
    var inSession: Bool = false
    
    var timer = Timer()
    
    var audioPlayer: AVAudioPlayer!
    var selectedSoundFileName: String = ""
    let sound: String = "note1"
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCircularTrackLayer()
        circularAnimationLayer()
        
        
        
//        startSession(startButton)
        
//        configureSessionButton()
//        configureResetSessionButton()
    }
    
    func createCircularTrackLayer() {
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 15
        trackLayer.fillColor = UIColor.clear.cgColor
//        trackLayer.lineCap = CAShapeLayerLineCap.round
        
//        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(trackLayer)
    }
    
    func circularAnimationLayer() {
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToRun)))
    }
    
    
    @objc func tapToRun() {
        print("Attempting to animate stroke")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 3
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "circular")
    }
    

    /*
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
*/
    
    // MARK:- Button configurations
    
    func configureSessionButton() {
        sessionButton.setTitle("Start Session", for: .normal)
        sessionButton.backgroundColor = .systemGreen
        
        addSessionButtonConstraints()
    }
    
    func configureResetSessionButton() {
        resetSessionButton.setTitle("Reset", for: .normal)
        resetSessionButton.backgroundColor = .black
        
        addResetSessionButtonConstraints()
    }
    
    // MARK:- Auto layout for buttons
    
    func addSessionButtonConstraints() {
        view.addSubview(sessionButton)
        sessionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sessionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            sessionButton.heightAnchor.constraint(equalToConstant: 50),
            sessionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            sessionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    func addResetSessionButtonConstraints() {
        view.addSubview(resetSessionButton)
        resetSessionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resetSessionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            resetSessionButton.heightAnchor.constraint(equalToConstant: 35),
//            resetSessionButton.widthAnchor.constraint(equalToConstant: 250)
            resetSessionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            resetSessionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50)
        ])
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


