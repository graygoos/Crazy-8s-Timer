//
//  InfoViewController.swift
//  Crazy-8s Timer
//
//  Created by Femi Aliu on 07/03/2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    
    var infoText = """
This is a Crazy-8s timer.
Sketch eight ideas in 8 minutes. You have 60 seconds to sketch an idea. The timer will beep every 60 seconds, prompting you to start sketching the next idea. At the end of the eighth minute, the timer will beep three times letting you know you've come to the end of the Crazy-8s session.
Happy sketching! 👍🏽
"""
    
    let infoTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.font = UIFont.systemFont(ofSize: 20)
//        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "About"
        
        infoTextLabel.text = infoText
        
        view.backgroundColor = .systemBackground
        
        infoTextConstraints()
        
    }
    
    
    // Mark:- Close View Controller
    
    @IBAction func closeInfoVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    // Mark:- Auto Layout
    
    func infoTextConstraints() {
        view.addSubview(infoTextLabel)
        NSLayoutConstraint.activate([
            infoTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            infoTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    

}
