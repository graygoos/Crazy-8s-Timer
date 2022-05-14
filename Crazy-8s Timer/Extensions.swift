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
