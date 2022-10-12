//
//  CircularAnimation.swift
//  Crazy-8s Timer
//
//  Created by Femi Aliu on 03/05/2022.
//

import UIKit


extension ViewController {
    
    // MARK: Animation methods
    
    func createCircularTrackLayer() {
        let center = view.center
        
        let circularPath = UIBezierPath(arcCenter: center, radius: view.frame.width * 0.40, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.trackColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.systemBackground.cgColor
        
        view.layer.addSublayer(trackLayer)
    }
    
    func circularAnimationLayer() {
        let center = view.center
        
        let circularPath = UIBezierPath(arcCenter: center, radius: view.frame.width * 0.40, startAngle: -CGFloat.pi / 2, endAngle: -2.5 * CGFloat.pi, clockwise: false)


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

        basicAnimation.toValue = 1

        basicAnimation.duration = CFTimeInterval(countDownTime) // var countDownTime: Int = 60 from above
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards

        basicAnimation.isRemovedOnCompletion = true

        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    
    func pulsatingEffect() {
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: view.frame.width * 0.40, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer = CAShapeLayer()
        
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 15
        pulsatingLayer.fillColor = UIColor.pulsingColor
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.position = view.center
        view.layer.addSublayer(pulsatingLayer)
        
        animatePulsatingLayer()
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
    
    
    
    
  /*
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
   */
    
    // reset circular animation
    func resetAnimation(layer: CAShapeLayer) {
//        let removeBasicAnimation = layer.removeAnimation(forKey: "basicAnimation")
        layer.removeAllAnimations()
        
    }

    
}


/*
 Pause, Resume and Persist animation in the background
 code below from:
 https://gist.github.com/ArtFeel/ad4b108f026e53723c7457031e291bc8
 */


//public extension CALayer {
//    var isAnimationPaused: Bool {
//        return speed == 0.0
//    }
//    
//    func pauseAnimations() {
//        if !isAnimationPaused {
//            let currentTime = CACurrentMediaTime()
//            let pausedTime = convertTime(currentTime, from: nil)
//            speed = 0.0
//            timeOffset = pausedTime
//        }
//    }
//    
//    func resumeAnimation() {
//        let pausedTime = timeOffset
//        speed = 1.0
//        timeOffset = 0.0
//        beginTime = 0.0
//        let currentTime = CACurrentMediaTime()
//        let timeSincePause = convertTime(currentTime, from: nil) - pausedTime
//        beginTime = timeSincePause
//    }
//    
//    
//    static private var persistentHelperKey = "CALayer.LayerPersistentHelper"
//    
//    func makeAnimationPersistent() {
//        var object = objc_getAssociatedObject(self, &CALayer.persistentHelperKey)
//        if object == nil {
//            object = LayerPersistentHelper(with: self)
//            let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//            objc_setAssociatedObject(self, &CALayer.persistentHelperKey, object, nonatomic)
//        }
//    }
//}


/*
public class LayerPersistentHelper {
    private var persistentAnimations: [String: CAAnimation] = [:]
//    private var persistentAnimations: [String: CABasicAnimation] = [:]
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

private extension LayerPersistentHelper {
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
        layer.pauseAnimations()
    }
}
*/
