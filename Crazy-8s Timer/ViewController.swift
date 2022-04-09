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
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let timerLabel: UILabel = {
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
    
    var displayLink: CADisplayLink!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.circularAnimationLayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Crazy-8s Timer"
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        setUpNotificationObservers()
        
//        pulsatingEffect()
        createCircularTrackLayer()
//        animatePulsatingLayer()
//        circularAnimationLayer()
        
        timerLabel.text = "\(countDownTime)"

        sessionCounter.text = "Sketch: \(sketchCount)"
        
        addLabelConstraints()
//        addSessionButtonConstraints()
//        addResetSessionButtonConstraints()

        beforeSessionButton()
        
        startButton.addTarget(self, action: #selector(startSession), for: .touchUpInside)
        sessionButton.addTarget(self, action: #selector(startSession), for: .touchUpInside)
        
//        resetSessionButton.isHidden = true
        resetSessionButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        resetSessionButton.setTitle("Reset", for: .normal)
        
//        displayLink = CADisplayLink(target: self, selector: #selector(basicAnimation))
//        displayLink.add(to: .main, forMode: .common)
    }
    
    @objc func startSession() {
        startButton.isHidden = true
        sessionButton.isHidden = false
        resetSessionButton.isHidden = false
        startSessionButton()
        InSessionResetSessionButton()
        if isTimerRunning == false {
            if countDownTime < 60 {
                resumeAnimation(layer: shapeLayer)
                startTimer()
                sessionButton.setTitle("Pause", for: .normal)
                sessionButton.backgroundColor = .systemYellow
                print("resume")
            } else {
                startTimer()
                basicAnimation()
//                animatePulsatingLayer()
                sessionButton.setTitle("Pause", for: .normal)
                sessionButton.backgroundColor = .systemYellow
//                resetSessionButton.isHidden = false
                resetSessionButton.isEnabled = true
                isTimerRunning = true
                print("start")
            }
            
        } else if pauseTapped == false && isTimerRunning == true {
            timer.invalidate()
            pauseAnimation(layer: shapeLayer)
            sessionButton.setTitle("Resume", for: .normal)
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
            sessionButton.setTitle("Start", for: .normal)
            resetSessionButton.isHidden = true
            playSound()
            audioPlayer.numberOfLoops = 2
            reset()
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
        sessionButton.setTitle("Start", for: .normal)
        sessionButton.backgroundColor = .systemGreen
//        startSession(startButton)
        timer.invalidate()
        resetSessionButton.isHidden = true
        sessionButton.isHidden = true
        startButton.isHidden = false
//        resetSessionButton.isEnabled = false
        isTimerRunning = false
//        inSession = false
        resetAnimation(layer: shapeLayer)
        print("reset")
    }
    
    
    // MARK: Animation
    
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
    
//        let circularPath = UIBezierPath(arcCenter: center, radius: view.frame.width * 0.40, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        let circularPath = UIBezierPath(arcCenter: center, radius: view.frame.width * 0.40, startAngle: -CGFloat.pi / 2, endAngle: -2.5 * CGFloat.pi, clockwise: false)


        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeEnd = 0
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.blue.cgColor
        
        trackLayer.addSublayer(shapeLayer)
    }
    
    
    func basicAnimation() {
        circularAnimationLayer()
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = 0.8
        basicAnimation.toValue = 1

        basicAnimation.duration = CFTimeInterval(countDownTime) // var countDownTime: Int = 60 from above
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
//        basicAnimation.fillMode = CAMediaTimingFillMode.backwards

        basicAnimation.isRemovedOnCompletion = true

        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    func pulsatingEffect() {
        let center = view.center
        
        let circularPath = UIBezierPath(arcCenter: center, radius: view.frame.width * 0.40, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer = CAShapeLayer()
        
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 15
        pulsatingLayer.fillColor = UIColor.yellow.cgColor
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(pulsatingLayer)
        
//        animatePulsatingLayer()
    }
    
    func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.2
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsingEffect")
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
    
    private func setUpNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleWhenInForeground), name: .NSExtensionHostWillEnterForeground, object: nil)
    }
    
    @objc func handleWhenInForeground() {
        basicAnimation()
        startSession()
        startTimer()
        print("App has entered foreground")
    }
    

    
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
    
    private enum Constants {
        static let padding: CGFloat = 0.35
    }
    
    // MARK: Auto Layout / Constraints
    
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


// MARK: NOTES

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


