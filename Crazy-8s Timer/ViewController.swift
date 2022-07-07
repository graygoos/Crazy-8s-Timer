//
//  ViewController.swift
//  Crazy-8s Timer
//
//  Created by Femi Aliu on 28/08/2021.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    let startCrazy8sSession = C8Button(backgroundColor: .systemGreen, title: "Start")
    let c8SessionButton = C8Button(backgroundColor: .systemGreen, title: "Pause")
    let resetC8Button = C8Button(backgroundColor: .systemRed, title: "Reset")
    
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
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 120)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        
        return button
    }()
    
    let sessionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pause", for: .normal)
        
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
    var pulsatingLayer: CAShapeLayer!
    var circularAnimationPosition: CAShapeLayer!
    
    
    var displayLink: CADisplayLink!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circularAnimationLayer()
        shapeLayer.makeAnimationPersistent()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Crazy-8s Timer"

        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenEnteringBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        pulsatingEffect()
        createCircularTrackLayer()
        circularAnimationLayer()
        shapeLayer.makeAnimationPersistent()
        
        timerLabel.text = "\(countDownTime)"

        sessionCounter.text = "Sketch: \(sketchCount)"
        
        addLabelConstraints()

        beforeSessionButton()
        
        startButton.addTarget(self, action: #selector(startSession), for: .touchUpInside)
        sessionButton.addTarget(self, action: #selector(startSession), for: .touchUpInside)
        
        resetSessionButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        resetSessionButton.setTitle("Reset", for: .normal)
        
//        displayLink = CADisplayLink(target: self, selector: #selector(basicAnimation))
//        displayLink.add(to: .main, forMode: .common)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        circularAnimationLayer()
        shapeLayer.makeAnimationPersistent()
        pulsatingLayer.makeAnimationPersistent()
        
//        if countDownTime == 60 && isTimerRunning == false && pauseTapped {
//            basicAnimation()
//        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        shapeLayer.makeAnimationPersistent()
//    }
    
    
    @objc func startSession() {
        startButton.isHidden = true
        sessionButton.isHidden = false
        resetSessionButton.isHidden = false
        startSessionButton()
        InSessionResetSessionButton()
        UIApplication.shared.isIdleTimerDisabled = true
        shapeLayer.makeAnimationPersistent()
        
        if isTimerRunning == false {
            if countDownTime < 60 {
                shapeLayer.resumeAnimation()
                startTimer()
                sessionButton.setTitle("Pause", for: .normal)
                sessionButton.backgroundColor = .systemYellow
                print("resume")
            } else {
                startTimer()
                basicAnimation()
                sessionButton.setTitle("Pause", for: .normal)
                sessionButton.backgroundColor = .systemYellow
                resetSessionButton.isEnabled = true
                isTimerRunning = true
                print("start")
            }
        } else if pauseTapped == false && isTimerRunning == true {
            pauseSession()
            shapeLayer.pauseAnimation()
            isTimerRunning = false
            print("pause")
        }
    }
    
    
    @objc func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(session), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
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
            sessionButton.setTitle("Start", for: .normal)
            resetSessionButton.isHidden = true
            playSound()
            audioPlayer.numberOfLoops = 2
            print("Crazy-8s session ended")
            reset()
        }
        
        timerLabel.text = "\(countDownTime)"
        sessionCounter.text = "Sketch: \(sketchCount)"
    }
    
    
    @objc func reset() {
        timer.invalidate()
        countDownTime = 60
        sketchCount = 1
        timerLabel.text = "\(countDownTime)"
        sessionCounter.text = "Sketch: \(sketchCount)"
        sessionButton.setTitle("Start", for: .normal)
        sessionButton.backgroundColor = .systemGreen
        timer.invalidate()
        resetSessionButton.isHidden = true
        sessionButton.isHidden = true
        startButton.isHidden = false
        isTimerRunning = false
        resetAnimation(layer: shapeLayer)
        UIApplication.shared.isIdleTimerDisabled = false
        UIDevice.vibrate()
        print("reset")
        
    }
    
    
    func pauseSession() {
        timer.invalidate()
        shapeLayer.pauseAnimation()
        isTimerRunning = false
        sessionButton.setTitle("Resume", for: .normal)
        sessionButton.backgroundColor = .systemGreen
        
    }
    
    // MARK: Background and foreground methods
    
    @objc func pauseWhenEnteringBackground() {
//        shapeLayer.makeAnimationPersistent()
        shapeLayer.pauseAnimation()
        pauseSession()
        print("Entered background, paused app")
    }
    
    
    @objc func backToForeground() {
//        shapeLayer.makeAnimationPersistent()
        
        if countDownTime < 60 {
            shapeLayer.pauseAnimation()
        } else if countDownTime == 60 && !isTimerRunning {
            basicAnimation()
        } else if shapeLayer.isAnimationPaused && pauseTapped {
            shapeLayer.pauseAnimation()
        } else {
            shapeLayer.resumeAnimation()
        }
        
//        if countDownTime == 60 && isTimerRunning == false {
//            basicAnimation()
//        }
    }
    
    
    // MARK: Auto Layout / Constraints
    
    private enum Constants {
        static let padding: CGFloat = 0.35
    }
    
    
    func beforeSessionButton() {
        sessionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.38),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.31),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    
    func startSessionButton() {
        sessionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sessionButton)
        
        NSLayoutConstraint.activate([
            sessionButton.heightAnchor.constraint(equalToConstant: 50),
            sessionButton.widthAnchor.constraint(equalToConstant: view.frame.width * Constants.padding),
            sessionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width * 0.10),
            sessionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        UIDevice.vibrate()
    }
    
    
    func InSessionResetSessionButton() {
        resetSessionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetSessionButton)
        
        NSLayoutConstraint.activate([
            resetSessionButton.heightAnchor.constraint(equalToConstant: 50),
            resetSessionButton.widthAnchor.constraint(equalToConstant: view.frame.width * Constants.padding),
            resetSessionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.10),
            resetSessionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        UIDevice.vibrate()
    }

    
    // MARK:- Auto Layout for labels
    
    func addLabelConstraints() {
  
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
        view.addSubview(sessionCounter)
        NSLayoutConstraint.activate([
            sessionCounter.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 5),
            sessionCounter.heightAnchor.constraint(equalToConstant: 40),
            sessionCounter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.31),
            sessionCounter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width * 0.31)
        ])
    }
}


public class LayerPersistentHelper {
    private var persistentAnimations: [String: CAAnimation] = [:]
    private var persistentSpeed: Float = 0.0
    private weak var layer: CAShapeLayer?
    
    public init(with layer: CAShapeLayer) {
        self.layer = layer
        addNotificationObservers()
    }
    
    deinit {
        removeNotificationObservers()
    }
}


extension LayerPersistentHelper {
    func addNotificationObservers() {
        let center = NotificationCenter.default
        let enterForeground = UIApplication.willEnterForegroundNotification
        let enterBackground = UIApplication.didEnterBackgroundNotification
        center.addObserver(self, selector: #selector(didBecomeActive), name: enterForeground, object: nil)
        center.addObserver(self, selector: #selector(willResignActive), name: enterBackground, object: nil)
    }
    
    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func persistAnimation(with keys: [String]?) {
        guard let layer = self.layer else { return }
        keys?.forEach { (key) in
            if let animation = layer.animation(forKey: key) {
                persistentAnimations[key] = animation
            }
        }
    }
    
    func restoreAnimation(with keys: [String]?) {
        guard let layer = self.layer else { return }
        keys?.forEach { (key) in
            if let animation = persistentAnimations[key] {
                layer.add(animation, forKey: key)
            }
        }
    }
}


@objc extension LayerPersistentHelper {
    func didBecomeActive() {
        guard let layer = self.layer else { return }
        restoreAnimation(with: Array(persistentAnimations.keys))
        persistentAnimations.removeAll()
        if persistentSpeed == 1.0 { // if layer was playing before background, resume it
            layer.resumeAnimation()
        }
    }
    
    func willResignActive() {
        guard let layer = self.layer else { return }
        persistentSpeed = layer.speed
        layer.speed = 1.0 // in case layer was paused from outside, set speed to 1.0 to get all animations
        persistAnimation(with: layer.animationKeys())
        layer.speed = persistentSpeed // restore original speed
        layer.pauseAnimation()
    }
}



// MARK: NOTES

//TODO:
// Start, Pause, Resume, Reset functionality of buttons ✅
// Fix timer bug - tapping start session button twice makes countdown run faster ✅
// Animation - Pause, Resume, Reset ✅
// Info Screen ✅
// Buttons - Initially only StartButton placed centrally in space below circular track, when StartButton is pressed, the Start Session and Reset buttons appear in their respective positions ✅
// AutoLayout - calculate the sizes and positions of circular track and buttons and text depending on size of screen - use multipliers - so it works seamlessly on all iPhones and iPads ✅
// Pulsing circular animation ✅
// CADisplayLink for circular animation
// Anti-clockwise animation ✅
// 11/05/2022
// pause app - timer and animation immediately app enters background (change button functionality)✅
// animation/timer/session continues from where it paused when it entered background when brought back to foreground ✅
// when app is in the foreground, the phone screen does not sleep/close till after the entire session is done ✅
// pulsing animation working when brought back from the background ✅

// add functionality of continuing in background for future version and also to strengthen my skills:-
// make app work in the background and chime every 60 seconds, continue session even if app is closed but not paused and send notification when session is done
// when in foreground and screen closed or not, show notification when done and/or every 60 seconds
// remove haptic feedback from settings screen



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
 -  settings icon top right of nav controller - change/select sounds, change/select themes
 */

/*
 Include button for google form in top left for users to give list of features they'd like to see
 */

/* Architecture of project - MVC */


