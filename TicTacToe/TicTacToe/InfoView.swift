//
//  InfoView.swift
//  TicTacToe
//
//  Created by Gianni Chen on 2/12/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class InfoView: UIView {
    
    // This gets called when the ViewController loads
    func startUp()
    {
        // Makes the background white, so that you can't see the stuff behind
        self.backgroundColor = UIColor.white
        
        // Adds the Label
        let infoLabel: UILabel = UILabel.init(frame: CGRect(x: 0, y: 400, width: 375, height: 50))
        infoLabel.text = "Put three of the same kind in a line to win"
        infoLabel.textAlignment = NSTextAlignment.center
        infoLabel.font = UIFont(name: infoLabel.font.fontName, size: 16)
        infoLabel.center.x = self.center.x
        self.addSubview(infoLabel)
        
        // Adds the Button
        let dismissButton: UIButton = UIButton.init(frame: CGRect(x: 0, y: 450, width: 375, height: 50))
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.setTitleColor(.blue, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        self.addSubview(dismissButton)
    }
    
    // This gets called when the info button is pressed
    func scrollDown()
    {
        // Brings the view to the front
        self.superview?.bringSubview(toFront: self)
        
        UIView.animate(withDuration: 3, animations: {
            //self.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        }) { (finished) in
            UIView.animate(withDuration: 3, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    // This gets called when you click on dismiss
    func dismiss()
    {
        UIView.animate(withDuration: 3, animations: {
            //self.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.frame = CGRect(x: 0, y: 667, width: 375, height: 667)
        }) { (finished) in
            UIView.animate(withDuration: 3, animations: {
                self.transform = CGAffineTransform.identity
            })
            // Resets the UIView position
            self.frame = CGRect(x: 0, y: -667, width: 375, height: 667)
        }
        
        
    }
}
