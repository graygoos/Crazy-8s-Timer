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
        
        return button
    }()
    
    let resetSessionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var countDownTime: Int = 60
    var sketchCount: Int = 1
    
    var resetTime = 0
    
    var isTimerRunning: Bool = false
    var inSession: Bool = false
    
    var timer = Timer()
    
    var audioPlayer: AVAudioPlayer!
    var selectedSoundFileName: String = ""
    let sound: String = "note1"
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.createCircularTrackLayer()
        self.circularAnimationLayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "Crazy-8s Timer"
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        createCircularTrackLayer()
//        circularAnimationLayer()
        
        timerLabel.text = "\(countDownTime)"
        sessionCounter.text = "Sketch: \(sketchCount)"
//        infoLabel.text = "Sketch 8 ideas in 8 minutes"
        infoLabel.text = "Crazy-8s timer"
        
        addLabelConstraints()
        addSessionButtonConstraints()
        addResetSessionButtonConstraints()
//        startSession(startButton)
        
//        configureSessionButton()
//        configureResetSessionButton()
        startSession()
        sessionButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
//        sessionButton.setTitle("Start Crazy-8 Session", for: .normal)
        
        resetSessionButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        resetSessionButton.setTitle("Reset", for: .normal)
    }
    
    @objc func startTimer() {
        basicAnimation()
//        circularAnimationLayer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(session), userInfo: nil, repeats: true)
        
    }
    
    @objc func session() {
//        circularAnimationLayer()
        if countDownTime > 0 {
            countDownTime -= 1
//            circularAnimationLayer()
        } else if sketchCount <= 7 {
            countDownTime = 60
            sketchCount += 1
            playSound()
        } else {
            timer.invalidate()
            sketchCount = 0
            sessionButton.setTitle("Start Crazy-8 Session", for: .normal)
            playSound()
            audioPlayer.numberOfLoops = 2
            reset()
            sessionButton.isEnabled = true
        }
//        circularAnimationLayer()
        timerLabel.text = "\(countDownTime)"
        sessionCounter.text = "Sketch: \(sketchCount)"
    }
    
    func startSession() {
        if self.inSession == false {
            timer.invalidate()
            isTimerRunning = false
            self.inSession = true
            self.sessionButton.setTitle("Start Crazy-8 Session", for: .normal)
            self.sessionButton.backgroundColor = .systemGreen
        } else {
            startTimer()
            self.inSession = false
            isTimerRunning = true
            self.sessionButton.setTitle("Pause Session", for: .normal)
            self.sessionButton.backgroundColor = .systemYellow
        }
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
        let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: false)
        
//        let endAngle = (-CGFloat.pi / 2)
//        let startAngle = 2 * CGFloat.pi + endAngle
//
//        let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: startAngle + endAngle, endAngle: endAngle, clockwise: true)

        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 25
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.blue.cgColor
        
        
        
       
        trackLayer.addSublayer(shapeLayer)
//        view.layer.addSublayer(shapeLayer)
//        basicAnimation()
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(session)))
    }
    
    
//    @objc func tapToRun() {
    func basicAnimation() {
//        print("Attempting to animate stroke")
        circularAnimationLayer()
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = 1
        basicAnimation.toValue = 0
//        basicAnimation.duration = 3
        basicAnimation.duration = CFTimeInterval(countDownTime)
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
//        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.isRemovedOnCompletion = true
        
//        shapeLayer.add(basicAnimation, forKey: "circular")
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
//        circularAnimationLayer()
//        startSession()
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
    }
    
/*
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(session), userInfo: nil, repeats: true)
    }

    // MARK:- Button configurations
//    @IBAction func startSession(_ sender: UIButton
    func configureSessionButton() {
//        sessionButton.setTitle("Start Session", for: .normal)
//        sessionButton.backgroundColor = .systemGreen
        
        if self.inSession == false {
            timer.invalidate()
            isTimerRunning = false
            self.inSession = true
            self.sessionButton.setTitle("Start Crazy-8 Session", for: .normal)
            self.sessionButton.backgroundColor = .systemGreen
        } else {
            startTimer()
            self.inSession = false
            isTimerRunning = true
            self.sessionButton.setTitle("Pause Session", for: .normal)
            self.sessionButton.backgroundColor = .systemYellow
        }
        
        addSessionButtonConstraints()
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
            sessionButton.setTitle("Start Crazy-8 Session", for: .normal)
            playSound()
            audioPlayer.numberOfLoops = 2
            reset()
            sessionButton.isEnabled = true
        }
        
        timerLabel.text = "\(countDownTime)"
        sessionCounter.text = "\(sessionCount)"
    }
    
    func configureResetSessionButton() {
        resetSessionButton.setTitle("Reset", for: .normal)
        resetSessionButton.backgroundColor = .systemBrown
        
            reset()
        
        addResetSessionButtonConstraints()
    }
    
    @objc func reset() {
        timer.invalidate()
        countDownTime = 60
        sessionCount = 1
        timerLabel.text = "\(countDownTime)"
        sessionCounter.text = "\(sessionCount)"
        sessionButton.setTitle("Start Crazy-8 Session", for: .normal)
        sessionButton.backgroundColor = .systemGreen
//        startSession(startButton)
        timer.invalidate()
    }
    
*/
    
   
/*
    
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

*/
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
    
    func addSessionButtonConstraints() {
        view.addSubview(sessionButton)
        sessionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sessionButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 100),
            sessionButton.heightAnchor.constraint(equalToConstant: 50),
            sessionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            sessionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    func addResetSessionButtonConstraints() {
        view.addSubview(resetSessionButton)
        resetSessionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            resetSessionButton.topAnchor.constraint(equalTo: sessionButton.bottomAnchor, constant: 50),
            resetSessionButton.heightAnchor.constraint(equalToConstant: 45),
//            resetSessionButton.widthAnchor.constraint(equalToConstant: 250)
            resetSessionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            resetSessionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            resetSessionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
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

// Pause timer, reset timer, toggle button title (text)/function and color✅
// plays sound when you start timer after completing session ✅
// placed reset function in else clause of session()

/* Bugs to fix:
 tapping start session button twice makes countdown run faster
 tapping the reset button pauses the timer, instead of restarting crazy-8s session
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


