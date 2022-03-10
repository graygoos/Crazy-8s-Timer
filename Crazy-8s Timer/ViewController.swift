//
//  ViewController.swift
//  Crazy-8s Timer
//
//  Created by Femi Aliu on 28/08/2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBrown
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let sessionCounter: UILabel = {
        let label = UILabel()
//        label.text = "1"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .systemBrown
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
//        label.text = "\(countDownTime)"
        label.font = UIFont.boldSystemFont(ofSize: 150)
//        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let sessionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Crazy-8 Session", for: .normal)
        
        return button
    }()
    
    let resetSessionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var countDownTime: Int = 60
    var sketchCount: Int = 1
    
    var resetTime = 0
    
    var isTimerRunning: Bool = false
    var inSession: Bool = false
    var pauseTapped: Bool = false
    
    var timer = Timer()
    
    var audioPlayer: AVAudioPlayer!
    var selectedSoundFileName: String = ""
    let sound: String = "note1"
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.circularAnimationLayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "Crazy-8s Timer"
//        navigationController?.navigationBar.prefersLargeTitles = true
        
//        view.backgroundColor = .black
        
        createCircularTrackLayer()
//        circularAnimationLayer()
        
        timerLabel.text = "\(countDownTime)"
//        timerLabel.textColor = .systemBrown
        sessionCounter.text = "Sketch: \(sketchCount)"
//        infoLabel.text = "Sketch 8 ideas in 8 minutes"
        infoLabel.text = "Crazy-8s timer"
        
        addLabelConstraints()
        addSessionButtonConstraints()
        addResetSessionButtonConstraints()

        sessionButton.addTarget(self, action: #selector(startSession), for: .touchUpInside)
        
        resetSessionButton.isHidden = true
        resetSessionButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        resetSessionButton.setTitle("Reset", for: .normal)
    }
    
    @objc func startSession() {
        if isTimerRunning == false {
            startTimer()
            sessionButton.setTitle("Pause Session", for: .normal)
            sessionButton.backgroundColor = .systemYellow
//            sessionButton.backgroundColor = .systemGreen
            resetSessionButton.isHidden = false
            isTimerRunning = true
        } else if pauseTapped == false && isTimerRunning == true {
            sessionButton.setTitle("Resume Session", for: .normal)
            sessionButton.backgroundColor = .systemGreen
            timer.invalidate()
            resetSessionButton.isHidden = false
            isTimerRunning = false
            pauseTapped = false
        }
//        } else {
//            startTimer()
////            sessionButton.setTitle("Resume Session", for: .normal)
////            sessionButton.backgroundColor = .systemOrange
//            isTimerRunning = true
//            pauseTapped = false
//        }
    }
    
    
    @objc func startTimer() {
//        startSession()
//        basicAnimation() // deComment to start animation
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(session), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    
    @objc func session() {
        if countDownTime > 0 {
            countDownTime -= 1
//            sessionButton.setTitle("Pause Session", for: .normal)
//            sessionButton.backgroundColor = .systemYellow
//            pauseTapped = true
//            startSession()
        } else if sketchCount <= 7 {
            countDownTime = 60
            sketchCount += 1
            playSound()
//            basicAnimation() // deComment to start animation
        } else {
            timer.invalidate()
            sketchCount = 0
            sessionButton.setTitle("Start Crazy-8 Session", for: .normal)
            resetSessionButton.isHidden = true
            playSound()
            audioPlayer.numberOfLoops = 2
            reset()
//            sessionButton.isEnabled = true
        }
        
//        resetSessionButton.isHidden = true
        timerLabel.text = "\(countDownTime)"
        sessionCounter.text = "Sketch: \(sketchCount)"
//        inSession = false
    }
    
    
    @objc func reset() {
        timer.invalidate()
        countDownTime = 60
        sketchCount = 1
        timerLabel.text = "\(countDownTime)"
        sessionCounter.text = "Sketch: \(sketchCount)"
        sessionButton.setTitle("Start Crazy-8 Session", for: .normal)
        sessionButton.backgroundColor = .systemGreen
//        startSession(startButton)
        timer.invalidate()
        resetSessionButton.isHidden = true
        isTimerRunning = false
//        inSession = false
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
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.blue.cgColor
        
        trackLayer.addSublayer(shapeLayer)
    }
    
    
    func basicAnimation() {

        circularAnimationLayer()
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0.8

        basicAnimation.duration = CFTimeInterval(countDownTime)
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards

        basicAnimation.isRemovedOnCompletion = true

        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    // Pause circular animation
    func pauseAnimation(layer: CAShapeLayer) {
        let paused: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = paused
    }
    
    // resume circular animation
    func resumeAnimation(layer: CAShapeLayer) {
        let paused = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - paused
        layer.beginTime = timeSincePause
    }
    
    // reset circular animation
    func resetAnimation(layer: CAShapeLayer) {
//        let removeBasicAnimation = layer.removeAnimation(forKey: "basicAnimation")
        layer.removeAllAnimations()
        
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

    
    // MARK:- Auto layout for buttons
    
    func addResetSessionButtonConstraints() {
        view.addSubview(resetSessionButton)
        resetSessionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resetSessionButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 100),
            resetSessionButton.heightAnchor.constraint(equalToConstant: 50),
            resetSessionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            resetSessionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    func addSessionButtonConstraints() {
        view.addSubview(sessionButton)
        sessionButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            sessionButton.heightAnchor.constraint(equalToConstant: 45),
            sessionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            sessionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            sessionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
    }
    
    
    // MARK:- Auto Layout for labels
    
    func addLabelConstraints() {
        
        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(sessionCounter)
        NSLayoutConstraint.activate([
            sessionCounter.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 50),
            sessionCounter.heightAnchor.constraint(equalToConstant: 50),
            sessionCounter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            sessionCounter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
}


// MARK:- NOTES

//TODO:
// Start, Pause, Resume, Reset functionality of buttons ✅
// Fix timer bug - tapping start session button twice makes countdown run faster ✅
// Animation - Pause, Resume, Reset
// Buttons - Initially only StartButton placed centrally in space below circular track, when StartButton is pressed, the Start Session and Reset buttons appear in their respective positions ✅
// AutoLayout - calculate the sizes and positions of circular track and buttons and text depending on size of screen - use multipliers - so it works seamlessly on all iPhones and iPads
// Info Screen
// second, microseconds, milliseconds countdown and place where sketch count presently is now - last last thing (and swap with where the seconds count is now)

// future feature - settings icon top right of nav controller - change/select sounds


// Pause timer, reset timer, toggle button title (text)/function and color✅
// plays sound when you start timer after completing session ✅
// placed reset function in else clause of session()

/* Bugs to fix:
 tapping start session button twice makes countdown run faster
 tapping the reset button pauses the timer, instead of restarting crazy-8s session✅
 I have to tap the startSession button twice to get it running initially
 */

/* Features to add:
 - chime beep once for each session and then beep thrice at the end of 8th session ✅
 -  Button to change 2 times: Start Crazy-8 Session, Pause Session
 -  Fix the design, make compatible with all iPhones and iPads
 -  light mode, dark mode support
 */

/*
 Include button for google form in top left for users to give list of features they'd like to see
 */

/* Architecture of project - MVC */


