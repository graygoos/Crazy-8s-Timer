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
        label.font = UIFont.boldSystemFont(ofSize: 180)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
//        label.text = "\(countDownTime)"
        label.font = UIFont.boldSystemFont(ofSize: 50)
//        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let sessionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Start Crazy-8 Session", for: .normal)
        button.setTitle("Start", for: .normal)
        
        return button
    }()
    
    let resetSessionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var countDownTime: Double = 60.00
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
    
    var displayLink: CADisplayLink!
    
    
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

        sessionCounter.text = "\(sketchCount)"

//        infoLabel.text = "Crazy-8s timer"
        
        addLabelConstraints()
//        addSessionButtonConstraints()
//        addResetSessionButtonConstraints()

//        buttonConstraints()
//        beforeSessionButton()
        startSessionButton()
        InSessionResetSessionButton()

        sessionButton.addTarget(self, action: #selector(startSession), for: .touchUpInside)
        
//        resetSessionButton.isHidden = true
        resetSessionButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        resetSessionButton.setTitle("Reset", for: .normal)
        
//        displayLink = CADisplayLink(target: self, selector: #selector(basicAnimation))
//        displayLink.add(to: .main, forMode: .common)
    }
    
    @objc func startSession() {
//        sessionButton.removeFromSuperview()
        if isTimerRunning == false {
            if countDownTime < 60 {
                resumeAnimation(layer: shapeLayer)
                startTimer()
                sessionButton.setTitle("Pause Session", for: .normal)
                sessionButton.backgroundColor = .systemYellow
                print("resume")
            } else {
                startTimer()
                basicAnimation()
                sessionButton.setTitle("Pause Session", for: .normal)
                sessionButton.backgroundColor = .systemYellow
//                resetSessionButton.isHidden = false
                resetSessionButton.isEnabled = true
                isTimerRunning = true
                print("start")
            }
            
        } else if pauseTapped == false && isTimerRunning == true {
            timer.invalidate()
            pauseAnimation(layer: shapeLayer)
            sessionButton.setTitle("Resume Session", for: .normal)
            sessionButton.backgroundColor = .systemGreen
//            resetSessionButton.isHidden = false
            isTimerRunning = false
            print("pause")
//            pauseTapped = false
        }
    }
    
    
    @objc func startTimer() {
//        startSession()
//        basicAnimation() // deComment to start animation
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(session), userInfo: nil, repeats: true)
//        let displayLink = CADisplayLink(target: self, selector: #selector(session))
//        displayLink.add(to: .current, forMode: .common)
        isTimerRunning = true
    }
    
    
    @objc func session() {
        if countDownTime > 0 {
            countDownTime -= 1
        } else if sketchCount <= 7 {
            countDownTime = 60
            sketchCount += 1
            playSound()
            basicAnimation() // deComment to start animation
        } else {
            timer.invalidate()
            sketchCount = 0
            sessionButton.setTitle("Start Crazy-8 Session", for: .normal)
            resetSessionButton.isHidden = true
            playSound()
            audioPlayer.numberOfLoops = 2
            reset()
        }
        
//        resetSessionButton.isHidden = true
        timerLabel.text = "\(countDownTime)"
        sessionCounter.text = "\(sketchCount)"
//        inSession = false
    }
    
    
    @objc func reset() {
        timer.invalidate()
        countDownTime = 60
        sketchCount = 1
        timerLabel.text = "\(countDownTime)"
        sessionCounter.text = "\(sketchCount)"
        sessionButton.setTitle("Start Crazy-8 Session", for: .normal)
        sessionButton.backgroundColor = .systemGreen
//        startSession(startButton)
        timer.invalidate()
//        resetSessionButton.isHidden = true
        resetSessionButton.isEnabled = false
        isTimerRunning = false
//        inSession = false
        resetAnimation(layer: shapeLayer)
        print("reset")
    }
    
    
    // MARK:- ANIMATION
    
    func createCircularTrackLayer() {
        let center = view.center
//        let center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.40)
        
        let circularPath = UIBezierPath(arcCenter: center, radius: view.frame.width * 0.40, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
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
//        let center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.40)
    
        let circularPath = UIBezierPath(arcCenter: center, radius: view.frame.width * 0.40, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)

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
    
    private enum Constants {
        static let padding: CGFloat = 0.35
    }
    
    // MARK:- Auto layout for buttons
    
    func beforeSessionButton() {
//        sessionButton.removeFromSuperview()
        sessionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sessionButton)
        
        NSLayoutConstraint.activate([
            sessionButton.heightAnchor.constraint(equalToConstant: 50),
            sessionButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.38),
            sessionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.31),
            sessionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width * 0.31),
            sessionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
//        sessionButton.removeFromSuperview()
    }
    func startSessionButton() {
        
        sessionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sessionButton)
        
        NSLayoutConstraint.activate([
            sessionButton.heightAnchor.constraint(equalToConstant: 50),
            sessionButton.widthAnchor.constraint(equalToConstant: view.frame.width * Constants.padding),
            sessionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width * 0.10),
            sessionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    func InSessionResetSessionButton() {
        resetSessionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetSessionButton)
        
        NSLayoutConstraint.activate([
            resetSessionButton.heightAnchor.constraint(equalToConstant: 50),
            resetSessionButton.widthAnchor.constraint(equalToConstant: view.frame.width * Constants.padding),
            resetSessionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.10),
            resetSessionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    func buttonConstraints() {
        if inSession && countDownTime <= 60 {
//            sessionButton.removeFromSuperview()
            startSessionButton()
            InSessionResetSessionButton()
            
        } else {
            beforeSessionButton()
//            sessionButton.removeFromSuperview()
        }
    }
    
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
        
//        view.addSubview(infoLabel)
//        NSLayoutConstraint.activate([
//            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
//            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
//            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
//        ])
        
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            timerLabel.heightAnchor.constraint(equalToConstant: 50),
            timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.31),
            timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width * 0.31)
        ])
        
        view.addSubview(sessionCounter)
            NSLayoutConstraint.activate([
                sessionCounter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                sessionCounter.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
}


// MARK:- NOTES

//TODO:
// Start, Pause, Resume, Reset functionality of buttons ✅
// Fix timer bug - tapping start session button twice makes countdown run faster ✅
// Animation - Pause, Resume, Reset ✅
// Info Screen ✅
// Buttons - Initially only StartButton placed centrally in space below circular track, when StartButton is pressed, the Start Session and Reset buttons appear in their respective positions
// AutoLayout - calculate the sizes and positions of circular track and buttons and text depending on size of screen - use multipliers - so it works seamlessly on all iPhones and iPads
// Pulsing circular animation
// CADisplayLink for circular animation
// Anti-clockwise animation
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


