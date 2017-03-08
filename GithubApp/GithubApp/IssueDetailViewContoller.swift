//
//  ViewController.swift
//  GithubApp
//
//  Created by Gianni Chen on 2/5/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class IssueDetailViewController: UIViewController {
    
    // Initializes variables
    var issueTitle: String = ""
    var issueUsername: String = ""
    var issueDate: String = ""
    var issueStatus: Bool = false
    var issueStatusString: String = ""
    var issueUrl: String = ""
    
    // Nothing to do here...
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // This is the main meat of the function, where it updates the variables and loads the labels
    func settings(_ title: String, _ username: String, _ date: String, _ status: Bool, _ url: String)
    {
        // Updates the instance variables
        self.issueTitle = title
        self.issueUsername = username
        self.issueDate = date
        self.issueStatus = status
        self.issueUrl = url
        
        // Changes the UIView's background color
        self.view.backgroundColor = UIColor.white
        
        // Creates a UILabel for the Title
        let titleLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 60, width: 375, height: 30))
        titleLabel.text = "Title: \(issueTitle)"
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.left
        self.view.addSubview(titleLabel)
        
        // Creates a UILabel for the Username
        let usernameLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 90, width: 375, height: 30))
        usernameLabel.text = "Username: \(issueUsername)"
        usernameLabel.textColor = UIColor.black
        usernameLabel.textAlignment = NSTextAlignment.left
        self.view.addSubview(usernameLabel)
        
        // Creates a UILabel for the Date
        let dateLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 120, width: 375, height: 30))
        dateLabel.text = "Date: \(issueDate)"
        dateLabel.textColor = UIColor.black
        dateLabel.textAlignment = NSTextAlignment.left
        self.view.addSubview(dateLabel)
        
        // Creates a UILabel for the Status
        let statusLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 150, width: 375, height: 30))
        if (issueStatus) { issueStatusString = "Open" }
        else { issueStatusString = "Closed" }
        statusLabel.text = "Status: \(issueStatusString)"
        statusLabel.textColor = UIColor.black
        statusLabel.textAlignment = NSTextAlignment.left
        self.view.addSubview(statusLabel)
        
        // Creates a UILabel for the Username
        let urlLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 180, width: 375, height: 30))
        urlLabel.text = "Issue URL: \(issueUrl)"
        urlLabel.textColor = UIColor.black
        urlLabel.textAlignment = NSTextAlignment.left
        self.view.addSubview(urlLabel)
    }
    
    // Function to open the URL on Safari
    func openURL()
    {
        UIApplication.shared.openURL(URL(string: issueUrl)!)
    }
}
