//
//  Extensions.swift
//  Crazy-8s Timer
//
//  Created by Femi Aliu on 04/05/2022.
//

import UIKit
import AudioToolbox


extension UIColor {
    
    static let pulsingColor: CGColor = UIColor(red: 0, green: 0.75, blue: 1, alpha: 1).cgColor
    
    static let trackColor: CGColor = UIColor(red: 0, green: 0.65, blue: 1, alpha: 1).cgColor
    
//    static let backgroundColor = UIColor(red: 21/255, green: 22/255, blue: 33/255, alpha: 1)
    
}


extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}


public extension CAShapeLayer {
    var isAnimationPaused: Bool {
        return speed == 0.0
    }

    func pauseAnimation() {
        if !isAnimationPaused {
            let currentTime = CACurrentMediaTime()
            let pausedTime = convertTime(currentTime, from: nil)
            speed = 0.0
            timeOffset = pausedTime
        }
    }

    func resumeAnimation() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let currentTime = CACurrentMediaTime()
        let timeSincePause = convertTime(currentTime, from: nil) - pausedTime
        beginTime = timeSincePause
    }
    
    
    static private var persistentHelperKey = "CAShapeLayer.LayerPersistentHelper"
    
    func makeAnimationPersistent() {
        var object = objc_getAssociatedObject(self, &CAShapeLayer.persistentHelperKey)
        if object == nil {
            object = LayerPersistentHelper(with: self)
            let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &CAShapeLayer.persistentHelperKey, object, nonatomic)
        }
    }
}
