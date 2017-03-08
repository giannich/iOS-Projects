//
//  ViewController.swift
//  It’s A Zoo in There
//
//  Created by Gianni Chen on 1/28/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIScrollViewDelegate {
    
    // I made the zoo, scrollView, and label variables global so that they can be accessed in the other methods
    var zoo: [Animal] = []
    let scrollView:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 375, height: 500))
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 500, width: 375, height: 167))
    var player: AVAudioPlayer?
    
    /**************
    * viewDidLoad *
    **************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIImage variables are created here in order to keep the code cleaner
        let chickenImage:UIImage = UIImage.init(named: "chickenSmall")!
        let porkImage:UIImage = UIImage.init(named: "porkSmall")!
        let beefImage:UIImage = UIImage.init(named: "beefSmall")!
        
        // The animals are initialized here with their respective values
        let chicken = Animal("Clucky", "Chicken", 1, chickenImage, "chickenSound")
        let pork = Animal("Oinky", "Pig", 3, porkImage, "porkSound")
        let beef = Animal("MooMoo", "Cow", 7, beefImage, "beefSound")
        
        // The animals are then appended, and finally shuffled through lazyShuffleAnimals()
        zoo.append(chicken)
        zoo.append(pork)
        zoo.append(beef)
        zoo.lazyShuffleAnimals()
        
        /**********
        * UILabel *
        **********/
        
        /// Attribution - http://stackoverflow.com/questions/34645943/how-to-center-uilabel-in-swift
        // This helped me to get the label to the center ^^^
        // We initially set the label to the first element of the zoo list because that's where we start at
        
        label.text = zoo[0].name
        label.textAlignment = NSTextAlignment.center
        label.center.x = self.view.center.x
        self.view.addSubview(label)
        
        /***************
        * UIScrollView *
        ***************/
        
        /// Attribution - http://stackoverflow.com/questions/6990349/cannot-scroll-uiscrollview
        // The rest of the stuff I learned through the built-in documentation
        // The "scrollView.delegate = self" line sets the delegate to ViewController (hence self)
        // since it adheres to the UIScrollViewDelegate protocol
        
        scrollView.contentSize = CGSize(width: 1125, height: 500)
        scrollView.bounces = true
        scrollView.isUserInteractionEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        /***********************
        * UIButtons & UIImages *
        ***********************/
        
        // Loops through the zoo array and puts the buttons and the images to their respective places
        for index in 0...2
        {
            /// Attribution - http://stackoverflow.com/questions/24102191/make-a-uibutton-programatically-in-swift
            /// Attribution - http://stackoverflow.com/questions/24030348/how-to-create-a-button-programmatically
            
            /***********
            * UIButton *
            ***********/
            
            let button:UIButton = UIButton(frame: CGRect(x: (index*375) + 150, y: 430, width: 100, height: 40))
            button.setTitle(zoo[index].species, for: .normal)
            button.setTitleColor(.black, for: .normal)
            // NOTE: This line below changes the button's position perfectly in the center!
            button.center.x = scrollView.center.x + CGFloat.init(index * 375)
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            scrollView.addSubview(button)
    
            /**********
            * UIImage *
            **********/
            
            let image:UIImageView = UIImageView(image: zoo[index].image)
            image.frame = CGRect(x: (index*375), y: 100, width: 375, height: 300)
            scrollView.addSubview(image)
        }
    }

    /**************************
    * didReceiveMemoryWarning *
    **************************/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /************************
    * buttonTapped Function *
    ************************/
    
    func buttonTapped(sender: UIButton!) {
        
        // Gets the index from the sender button's tag
        let index = sender.tag
        
        /****************
        * Sound Section *
        ****************/
        
        // Plays the sound, I had no idea how to make it outside of a try catch format, so I left it as it is...
        
        // WARNING: I think somewhere in this little try-catch section there is something that prints a lot of
        // information into stdout, but I can't figure where, so don't get alarmed with the ton of info dump
        // Hint: It's not the print error section...
        
        // ALSO NOTE: ALL THE SOUNDS ARE FROM THE HELL BOVINE MONSTERS FROM THE SECRET COW LEVEL IN DIABLO 2
        // YES THIS IS A FEATURE, NOT A BUG, CHICKENS AND PIGS ALSO MOOOOOO
        
        /// Attribution - http://stackoverflow.com/questions/32036146/how-to-play-a-sound-in-swift-2-and-3
        guard let sound = NSDataAsset(name: zoo[index].soundPath) else {
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
        
        /****************
        * Alert Section *
        ****************/
        
        // Initializes the strings using the Animal's data
        let title = "\(zoo[index].name)"
        let message = "\(zoo[index].name) the \(zoo[index].species) was \(zoo[index].age) years old"
        let button = "D:"
        
        // I just copied and pasted the part below from the BullsEye Project
        // Creates an instance of an alert and an instance of action with the above title, message, and button text
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: button, style: .default, handler: nil)
        
        // Attaches the action action to alert and then displays it
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        // Finally dumps the info into stdout
        zoo[index].dumpAnimalObject()
    }
    
    /****************************************
    * scrollViewDidEndDecelerating Function *
    ****************************************/
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // These conditionals set the respective names from zoo and alpha to 100%
        if scrollView.contentOffset.x == 0
        {
            label.text = zoo[0].name
            label.alpha = 1
        }
        else if scrollView.contentOffset.x == 375
        {
            label.text = zoo[1].name
            label.alpha = 1
        }
        else if scrollView.contentOffset.x == 750
        {
            label.text = zoo[2].name
            label.alpha = 1
        }
    }
    
    /*******************************
    * scrollViewDidScroll Function *
    *******************************/
    
    // This function creates the cool disappearing effect by keeping track of the scrollview offset
    // and then setting the alpha as a percentage of how far the user has scrolled
    // It is divided into 4 different sections as the transition between zoo[0] to zoo[1] and zoo[1] to zoo[2]
    // require 2 different labels each, for a total of 4 different conditionals
    
    // Warning! Complex math below!
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.x

        // Decreasing alpha for first animal
        if x > 0 && x < 187.5
        {
            label.text = zoo[0].name
            label.alpha = ( 100 - (100/187.5) * (x - 0) ) / 100
        }
        // Increasing alpha for second animal
        else if x > 187.5 && x < 375
        {
            label.text = zoo[1].name
            label.alpha = ( (100/187.5) * (x - 187.5) ) / 100
        }
        // Decreasing alpha for second animal
        else if x > 375 && x < 562.5
        {
            label.text = zoo[1].name
            label.alpha = ( 100 - (100/187.5) * (x - 375) ) / 100
        }
        // Increasing alpha for third animal
        else if x > 562.5 && x < 750
        {
            label.text = zoo[2].name
            label.alpha = ( (100/187.5) * (x - 562.5) ) / 100
        }
    }
}

/******************
* Array Extension *
******************/

extension Array {
    
    // Lazily shuffles the stuff inside an array of size 3
    mutating func lazyShuffleAnimals()
    {
        // Gets a random value between 0 and 5
        let randVal:Int = Int(arc4random_uniform(5))
        var randArrays: [[Int]] = []
        var index:Int
        
        // These arrays cover all the different permutations of the array [0, 1, 2]
        // I needed to do this because a simple randomizing function replaces the numbers in the sample set
        randArrays.append([0, 1, 2])
        randArrays.append([0, 2, 1])
        randArrays.append([1, 0, 2])
        randArrays.append([1, 2, 0])
        randArrays.append([2, 0, 1])
        randArrays.append([2, 1, 0])
        
        // Copies the first 3 elements in position 4, 5, and 6
        for i in 0...2
        {
            self.append(self[i])
        }
        
        // Then replaces the first 3 elements by popping and replacing an index at random
        
        // For example, if randVal == 3, then the resulting array is 0, 2, 1
        // So the 6th element goes to index 0
        // The 5th element goes to index 2
        // And the 4th element goes to index 1
        
        // So if you had chicken, pork, and beef, you would get beef, chicken, and pork after the lazyshuffle
        
        for i in 0...2
        {
            index = randArrays[randVal][i]
            self[index] = self.popLast()!
        }
        
    }
}

