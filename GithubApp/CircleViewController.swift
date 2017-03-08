//
//  CircleViewController.swift
//  GithubApp
//
//  Created by Gianni Chen on 2/6/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {
    
    // Initializes variables
    var allIssues: Int = 0
    var openIssues: Int = 0
    var closedIssues: Int = 0
    var openLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 250, width: 200, height: 50))
    var closedLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 300, width: 200, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Attribution - http://stackoverflow.com/questions/29616992/how-do-i-draw-a-circle-in-ios-swift
        // Creates a Green Circle
        let greenPath = UIBezierPath(arcCenter: CGPoint(x: 187.5,y: 300), radius: CGFloat(150), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        let greenLayer = CAShapeLayer()
        greenLayer.path = greenPath.cgPath
        greenLayer.fillColor = UIColor.clear.cgColor
        greenLayer.strokeColor = UIColor.green.cgColor
        greenLayer.lineWidth = 10
        self.view.layer.addSublayer(greenLayer)
        
        // Creates a Red Circle
        let redPath = UIBezierPath(arcCenter: CGPoint(x: 187.5,y: 300), radius: CGFloat(120), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        let redLayer = CAShapeLayer()
        redLayer.path = redPath.cgPath
        redLayer.fillColor = UIColor.clear.cgColor
        redLayer.strokeColor = UIColor.red.cgColor
        redLayer.lineWidth = 10
        self.view.layer.addSublayer(redLayer)
        
        // Changes the UIView's background color
        self.view.backgroundColor = UIColor.white
        
        // Creates a UILabel for the Open Issues
        openLabel.text = "\(openIssues) Open Issues"
        openLabel.textColor = UIColor.green
        openLabel.font = UIFont(name: openLabel.font.fontName, size: 24)
        openLabel.textAlignment = NSTextAlignment.center
        openLabel.center.x = self.view.center.x
        self.view.addSubview(openLabel)
    
        // Creates a UILabel for the Open Issues
        closedLabel.text = "\(closedIssues) Closed Issues"
        closedLabel.textColor = UIColor.red
        closedLabel.font = UIFont(name: openLabel.font.fontName, size: 24)
        closedLabel.textAlignment = NSTextAlignment.center
        closedLabel.center.x = self.view.center.x
        self.view.addSubview(closedLabel)
    }
    
    // Updates the labels, need to refresh both tabs first though
    func settings(_ open: Int, _ all: Int)
    {
        self.allIssues = all
        self.openIssues = open
        self.closedIssues = all - open
        
        openLabel.text = "\(openIssues) Open Issues"
        closedLabel.text = "\(closedIssues) Closed Issues"
    }
}
