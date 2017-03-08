//
//  ViewController.swift
//  BullsEye
//
//  Created by Gianni Chen on 1/21/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Declares and initializes the values
    var currentValue: Int = 0
    var targetValue: Int = 0
    var score: Int = 0
    var round: Int = 0
    var chain: Int = 0
    var highChain: Int = 0

    // Establishes the connection between the aobve variables and their respective labels
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var chainLabel: UILabel!
    @IBOutlet weak var highChainLabel: UILabel!

    // The viewController runs this method as soon as it finishes loading
    override func viewDidLoad() {
        super.viewDidLoad()
        startOver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // This method is invoked when the Hit Me! button is pressed
    @IBAction func showAlert() {
        
        // The difference is gotten through the absolute value between targetValue and currentValue, it is then added to score
        let difference = abs(targetValue - currentValue)
        score += (100 - difference)
        
        // Conditional statements to determine the title, the button flavor text and any extra points
        let title: String
        let button: String
        if difference == 0 {
            title = "Eh even a kid can do it"
            button = "Aight"
            chain += 1
            score += Int(pow(Double(100),Double(chain)))        /* Higher chains lead to even higher score multipliers */
        } else if difference == 1 {
            title = "Try harder!"
            button = "I was close"
            score += 50
            chain = 0
        } else if difference < 5 {
            title = "You suck!"
            button = "I know"
            chain = 0
        } else if difference < 10 {
            title = "You suck hard!"
            button = "I know :("
            chain = 0
        } else {
            title = "You should consider a carrer as a stormtrooper"
            button = "Where do I sign up?"
            chain = 0
        }
        
        // Builds a message with currentValue, targetValue, and difference
        let message = "The value of the slider is: \(currentValue)\nThe target value is: \(targetValue)\nYou missed the target by \(difference)!"
        
        // Creates an instance of an alert and an instance of action with the above title, message, and button text
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: button, style: .default, handler: { action in self.startNewRound()})
        
        // Attaches the action action to alert and then displays it
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Updates the current value from the slider's value
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    // Starts a new round by updating the score, resetting the slider, and incrementing the round counter
    func startNewRound() {
        targetValue = 1 + Int(arc4random_uniform(100))
        round += 1
        currentValue = 50
        slider.value = Float(currentValue)
        
        // Checks if the highChain is being surpassed
        if chain > highChain {
            highChain = chain
        }
        
        // Updates the labels with their respective values
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
        chainLabel.text = String(chain)
        highChainLabel.text = String(highChain)
    }
    
    // Resets the score and the round numbers, but does not reset the high chain
    @IBAction func startOver() {
        score = 0
        round = 0
        chain = 0
        startNewRound()
    }
}

