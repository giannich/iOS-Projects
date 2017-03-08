//
//  ViewController.swift
//  TicTacToe
//
//  Created by Gianni Chen on 2/11/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Initializes the pebble count
    var pebbleCount: Int = 0
    
    // Assigns each UIImage a path to its respective image
    let circleImage: UIImage = UIImage.init(named: "circleIcon")!
    let crossImage: UIImage = UIImage.init(named: "crossIcon")!
    let gridImage: UIImage = UIImage.init(named: "gridIcon")!
    let horizontalImage: UIImage = UIImage.init(named: "horizontalIcon")!
    let verticalImage: UIImage = UIImage.init(named: "verticalIcon")!
    let diag1Image: UIImage = UIImage.init(named: "diag1Icon")!
    let diag2Image: UIImage = UIImage.init(named: "diag2Icon")!
    
    // Initializes the gridUIView
    var UIViewGrid: [UIView?] = Array(repeating: nil, count: 9)
    var isGridOccupied: [Int] = Array(repeating: 0, count: 9)
    
    // Creates imageViews for the pebbles
    var crossImageView: PebbleImageView = PebbleImageView.init(frame: CGRect(x: 75, y: 525, width: 100, height: 100))
    var circleImageView: PebbleImageView = PebbleImageView.init(frame: CGRect(x: 200, y: 525, width: 100, height: 100))
    
    // Initializes the infoView
    var infoView: InfoView = InfoView.init(frame: CGRect(x: 0, y: -667, width: 375, height: 667))
    
    // Gets called when the ViewController is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGame()
    }
    
    // Sets up the game
    func setupGame()
    {
        // Resets the pebble count
        pebbleCount = 0
        
        // Creates the 8 UIViews and attaches them to the ViewController
        for i in 0...8
        {
            isGridOccupied[i] = 0
            let tempUIView: UIView = UIView.init(frame: CGRect(x: (i % 3) * 125, y: (i / 3) * 125 + 100, width: 125, height: 125))
            tempUIView.backgroundColor = UIColor.clear
            UIViewGrid[i] = tempUIView
            self.view.addSubview(tempUIView)
        }
        
        // Creates a title Label and puts it above the grid
        let titleLabel: UILabel = UILabel.init(frame: CGRect(x: 0, y: 30, width: 375, height: 50))
        titleLabel.text = "Tic-Tac-Toe!"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 45)
        titleLabel.center.x = self.view.center.x
        self.view.addSubview(titleLabel)
        
        // Sets up the info button
        let infoButton: UIButton = UIButton.init(type: UIButtonType.infoLight)
        infoButton.frame = CGRect(x: 330, y: 600, width: 20, height: 20)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        self.view.addSubview(infoButton)
        
        // Sets up the infoView
        infoView.startUp()
        self.view.addSubview(infoView)
        
        // Puts the gridImageView on the background
        let gridImageView: UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 100, width: 375, height: 375))
        gridImageView.image = gridImage
        self.view.addSubview(gridImageView)
    
        // Sets up the Cross PebbleImageView
        crossImageView.settings(isCross: true, parentView: self)
        crossImageView.isTouch(true)
        crossImageView.createPanGestureRecognizer(targetView: crossImageView)
        self.view.addSubview(crossImageView)
        
        // Sets up the Circle PebbleImageView
        circleImageView.settings(isCross: false, parentView: self)
        circleImageView.isTouch(false)
        circleImageView.createPanGestureRecognizer(targetView: circleImageView)
        self.view.addSubview(circleImageView)
    }
    
    // Processes whatever happens when a user puts down a pebble
    func didEndPlacing(_ gridLoc: Int, _ isCross: Bool)
    {
        // Increases the pebble count
        pebbleCount += 1
        
        // Creates a new instance of the UIImageView to be attached to the UIView
        let placedImageView: UIImageView = UIImageView.init(frame: CGRect(x: 12.5, y: 12.5, width: 100, height: 100))
        
        // If we just placed a Cross, we disable it, enable the Circle and record it on isGridOccupied
        if (isCross)
        {
            crossImageView.isTouch(false)
            circleImageView.isTouch(true)
            placedImageView.image = crossImage
            isGridOccupied[gridLoc] = 1
        }
        // If we just placed a Circle, we disable it, enable the Cross and record it on isGridOccupied
        else
        {
            circleImageView.isTouch(false)
            crossImageView.isTouch(true)
            placedImageView.image = circleImage
            isGridOccupied[gridLoc] = -1
        }
        
        // Finally attaches the UIImageView to the UIViewGrid array
        UIViewGrid[gridLoc]?.addSubview(placedImageView)
        
        // Only checks win conditions after the 4th pebble has been placed
        if (pebbleCount > 4)
        {
            if (checkWinCondition(isCross) == 1) { endGame(1) }
            else if (checkWinCondition(isCross) == -1) { endGame(-1) }
        }
        
        // If we reach 9 pebbles and noboy has won yet, then it's a tie
        if (pebbleCount == 9)
        {
            endGame(0)
        }
    }
    
    // Gets called in order to check who has won
    func checkWinCondition(_ isCross: Bool) -> Int
    {
        // Checks the win conditions for cross
        if (isCross)
        {
            print("Cheking win conditions for cross")
            // If the central grid is occupied, we first check for the 4 intersections
            if (isGridOccupied[4] == 1)
            {
                // Checks the 4 different intersections
                if ((isGridOccupied[1] + isGridOccupied[7]) == 2)
                {
                    print("Cross won")
                    drawWinLine(4)
                    return 1
                }
                else if ((isGridOccupied[3] + isGridOccupied[5]) == 2)
                {
                    print("Cross won")
                    drawWinLine(1)
                    return 1
                }
                else if ((isGridOccupied[0] + isGridOccupied[8]) == 2)
                {
                    print("Cross won")
                    drawWinLine(6)
                    return 1
                }
                else if ((isGridOccupied[2] + isGridOccupied[6]) == 2)
                {
                    print("Cross won")
                    drawWinLine(7)
                    return 1
                }
            }
            // Then, we check for the top-left corner
            if (isGridOccupied[0] == 1)
            {
                // Checks the top row, and then the left column
                if ((isGridOccupied[1] + isGridOccupied[2]) == 2)
                {
                    print("Cross won")
                    drawWinLine(0)
                    return 1
                }
                else if ((isGridOccupied[3] + isGridOccupied[6]) == 2)
                {
                    print("Cross won")
                    drawWinLine(3)
                    return 1
                }
            }
            // And finally, we check for the bottom-right corner
            if (isGridOccupied[8] == 1)
            {
                // Checks the bottom row, and then the right column
                if ((isGridOccupied[6] + isGridOccupied[7]) == 2)
                {
                    print("Cross won")
                    drawWinLine(2)
                    return 1
                }
                else if ((isGridOccupied[2] + isGridOccupied[5]) == 2)
                {
                    print("Cross won")
                    drawWinLine(5)
                    return 1
                }
            }
        }
        
        // Checks the win conditions for circle
        else
        {
            print("Cheking win conditions for circle")
            // If the central grid is occupied, we first check for the 4 intersections
            if (isGridOccupied[4] == -1)
            {
                // Checks the 4 different intersections
                if ((isGridOccupied[1] + isGridOccupied[7]) == -2)
                {
                    print("Circle won")
                    drawWinLine(4)
                    return -1
                }
                else if ((isGridOccupied[3] + isGridOccupied[5]) == -2)
                {
                    print("Circle won")
                    drawWinLine(1)
                    return -1
                }
                else if ((isGridOccupied[0] + isGridOccupied[8]) == -2)
                {
                    print("Circle won")
                    drawWinLine(6)
                    return -1
                }
                else if ((isGridOccupied[2] + isGridOccupied[6]) == -2)
                {
                    print("Circle won")
                    drawWinLine(7)
                    return -1
                }
            }
            // Then, we check for the top-left corner
            if (isGridOccupied[0] == -1)
            {
                // Checks the top row, and then the left column
                if ((isGridOccupied[1] + isGridOccupied[2]) == -2)
                {
                    print("Circle won")
                    drawWinLine(0)
                    return -1
                }
                else if ((isGridOccupied[3] + isGridOccupied[6]) == -2)
                {
                    print("Circle won")
                    drawWinLine(3)
                    return -1
                }
            }
            // And finally, we check for the bottom-right corner
            if (isGridOccupied[8] == -1)
            {
                // Checks the bottom row, and then the right column
                if ((isGridOccupied[6] + isGridOccupied[7]) == -2)
                {
                    print("Circle won")
                    drawWinLine(2)
                    return -1
                }
                else if ((isGridOccupied[2] + isGridOccupied[5]) == -2)
                {
                    print("Circle won")
                    drawWinLine(5)
                    return -1
                }
            }
        }
        // Else, return 0 since the game hasn't been won
        print("It's a tie")
        return 0
    }
    
    // Draws the win line by creating a UIImageview and slapping it into ViewController in the right place
    func drawWinLine(_ winCond: Int)
    {
        // Draws a horizontal line
        if (winCond < 3)
        {
            let winImageView: UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 100 + (-125 + winCond * 125), width: 375, height: 375))
            winImageView.image = horizontalImage
            self.view.addSubview(winImageView)
        }
        // Draws a vertical line
        else if (winCond < 6)
        {
            let winImageView: UIImageView = UIImageView.init(frame: CGRect(x: (-125 + (winCond - 3) * 125) + 5, y: 100, width: 375, height: 375))
            winImageView.image = verticalImage
            self.view.addSubview(winImageView)
        }
        // Draws a top-down diagonal line
        else if (winCond == 6)
        {
            let winImageView: UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 100, width: 375, height: 375))
            winImageView.image = diag1Image
            self.view.addSubview(winImageView)
        }
        // Draws a bottom-up diagonal line
        else if (winCond == 7)
        {
            let winImageView: UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 100, width: 375, height: 375))
            winImageView.image = diag2Image
            self.view.addSubview(winImageView)
        }
    }
    
    // Gets called if the game ends
    func endGame(_ withWinner: Int)
    {
        // We play the win sound here, doesn't matter from whom we call it from
        crossImageView.playSound(4)
        
        // Sets up the message
        var message: String
        
        if (withWinner == 1) { message = "X Wins!" }
        else if (withWinner == -1) { message = "O Wins!" }
        else { message = "It's a Tie!" }

        // Creates an instance of an alert and an instance of action with the above title, message, and button text
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "New Game", style: .default, handler: { action in self.resetGame()})
        
        // Attaches the action action to alert and then displays it
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // This method is invoked when the info button is pressed
    func resetGame()
    {
        print("Resetting Game")
        /// Attribution - http://stackoverflow.com/questions/24312760/how-to-remove-all-subviews-of-a-view-in-swift
        // Removes all views from UIViewController
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        // Then repopulates them
        setupGame()
    }
    
    // Pulls down the custom UIView
    func showInfo()
    {
        infoView.scrollDown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

