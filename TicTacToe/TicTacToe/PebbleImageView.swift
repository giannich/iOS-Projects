//
//  PebbleImageView.swift
//  TicTacToe
//
//  Created by Gianni Chen on 2/11/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit
import AVFoundation

class PebbleImageView: UIImageView {
    
    // Settings
    let crossImage: UIImage = UIImage.init(named: "crossIcon")!
    let circleImage: UIImage = UIImage.init(named: "circleIcon")!
    var isCross: Bool = false
    var lastLocation: CGPoint?
    var parentView: ViewController?
    var player: AVAudioPlayer?
    
    // Sets the image and whether the imageview is a cross or a circle
    func settings(isCross: Bool, parentView: ViewController)
    {
        self.isCross = isCross
        self.parentView = parentView
        
        // This determines the image and its location within the main view
        if (self.isCross)
        {
            self.image = crossImage
            lastLocation = CGPoint(x: 75, y: 525)
        }
        else
        {
            self.image = circleImage
            lastLocation = CGPoint(x: 200, y: 525)
        }
    }
    
    // Determines whether we can interact with the imageview and handles the alpha
    func isTouch(_ touchable: Bool)
    {
        if (touchable)
        {
            self.isUserInteractionEnabled = true
            self.isMultipleTouchEnabled = true
            self.alpha = 1
            animate()
        }
        else
        {
            self.isUserInteractionEnabled = false
            self.isMultipleTouchEnabled = false
            self.alpha = 0.5
        }
    }

    /// Attribution - http://stackoverflow.com/questions/32368905/how-to-programmatically-send-a-pangesture-in-swift
    func createPanGestureRecognizer(targetView: UIImageView)
    {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        targetView.addGestureRecognizer(panGesture)
        panGesture.cancelsTouchesInView = false
    }
    
    /// Attribution - http://stackoverflow.com/questions/33824260/swift-which-methods-are-needed-to-implement-a-draggable-uiimageview
    // This function here is called whenever we drag around the pebble
    // What is does is essentially continuously updating the location of the imageview
    func handlePanGesture(_ panGesture: UIPanGestureRecognizer)
    {        
        let translation = panGesture.translation(in: self.superview!)
        self.center.x = lastLocation!.x + translation.x
        self.center.y = lastLocation!.y + translation.y
    }
    
    // This function is called whenever we touch the imageView
    override func touchesBegan(_: Set<UITouch>, with: UIEvent?)
    {
        // Promote the touched view
        self.superview?.bringSubview(toFront: self)
        
        // Plays the sound according to the pebble's type
        if (isCross) {playSound(1)}
        else {playSound(2)}
        
        // Remember original location
        lastLocation = self.center
    }
    
    // This function is called whenever we lift our finger from the imageView
    override func touchesEnded(_: Set<UITouch>, with: UIEvent?)
    {
        // We initialize some variables here to keep track of things easier
        let adjX: Int = Int(self.center.x)
        let adjY: Int = Int(self.center.y - 100)
        
        let indX: Int = (adjX / 125) % 3
        let indY: Int = (adjY / 125) % 3
        
        // If we are within the grid bounds and the place is not already occupied
        // We will snap in the pebble into place and notify that we placed it
        if (adjY >= 0 && adjY <= 375 && parentView?.isGridOccupied[indX + indY * 3] == 0)
        {
            // Notifies ViewController that we placed the pebble
            print("Placed pebble at grid \(indX + indY * 3)")
            parentView?.didEndPlacing((indX + indY * 3), self.isCross)
        }
        // Otherwise we play the buzzer sound
        else
        {
            playSound(3)
        }
        
        // Whatever happens, we snap back the imageView
        self.center.y = 525 + 50
        if (isCross) { self.center.x = 75 + 50 }
        else { self.center.x = 200 + 50 }
        
        // Remember original location
        lastLocation = self.center
    }
    
    /// Attribution - http://stackoverflow.com/questions/22395712/making-an-animation-to-expand-and-shrink-an-uiview
    // This function grows and then shrinks the imageview, I have no idea what's going on here, but it works
    func animate()
    {
        UIView.animate(withDuration: 1, animations: {
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
        }) { (finished) in
            UIView.animate(withDuration: 1, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    // This function handles the sound playing
    func playSound(_ soundIndex: Int)
    {
        // This switch case determines which sound is going to be played
        var soundPath: String
        
        switch soundIndex
        {
            case 1:
                soundPath = "crossSound"
                break
            case 2:
                soundPath = "circleSound"
                break
            case 3:
                soundPath = "buzzerSound"
                break
            case 4:
                soundPath = "winSound"
                break
            default:
                soundPath = "buzzerSound"
        }
        
        // Plays the sound, taken from "It's A Zoo in There Project"
        /// Attribution - http://stackoverflow.com/questions/32036146/how-to-play-a-sound-in-swift-2-and-3
        guard let sound = NSDataAsset(name: soundPath) else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}
