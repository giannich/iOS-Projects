//
//  ViewController.swift
//  GithubApp
//
//  Created by Gianni Chen on 2/5/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    // Initializes the number of issues
    var openIssues: Int = 0
    var allIssues: Int = 0
    
    // Initializes the three tabs
    let open: IssueTableViewController = IssueTableViewController()
    let navOpen: UINavigationController = UINavigationController()
    
    let all: IssueTableViewController = IssueTableViewController()
    let navAll: UINavigationController = UINavigationController()
    
    let status: CircleViewController = CircleViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UINavigationController settings for Open Tab
        navOpen.pushViewController(open, animated: true)
        navOpen.navigationBar.topItem?.title = "Open"
        open.pullOnlyOpenIssues(true)
        open.whoCreatedMe(self)
        
        // UINavigationController settings for All Tab
        navAll.pushViewController(all, animated: true)
        navAll.navigationBar.topItem?.title = "All"
        all.pullOnlyOpenIssues(false)
        all.whoCreatedMe(self)
        
        /// Attribution - http://stackoverflow.com/questions/6183762/problem-adding-tab-bar-items-to-uitabbar
        navOpen.tabBarItem = UITabBarItem(title: "Open", image: UIImage(named: "GitIcon"), tag: 1)
        navAll.tabBarItem = UITabBarItem(title: "All", image: UIImage(named: "GitIcon"), tag: 2)
        status.tabBarItem = UITabBarItem(title: "Status", image: UIImage(named: "GitIcon"), tag: 3)
        
        viewControllers = [navOpen, navAll, status]
        setViewControllers(viewControllers, animated: true)
    }
    
    // This function here is called by the IssueTableViewController to create a new IssueDetailViewController
    // Which is then pushed on top of the UINavigationController
    func loadDetail(_ title: String, _ username: String, _ date: String, _ status: Bool, _ openOnly: Bool, _ url: String)
    {
        // Creates an IssueDetailViewController and sets up its format
        let detail: IssueDetailViewController = IssueDetailViewController()
        detail.settings(title, username, date, status, url)
        
        // I set the action to nil because I ran out of time...
        // I could not get it to hook up to the openURL function in IssueDetailViewController, but at least the button is there
        if (openOnly)
        {
            navOpen.pushViewController(detail, animated: true)
            let URLButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
            detail.navigationItem.rightBarButtonItem = URLButton
        }
        else
        {
            navAll.pushViewController(detail, animated: true)
            let URLButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
            detail.navigationItem.rightBarButtonItem = URLButton
        }
    }
    
    // Updates the third tab depending on who called it
    // Note: Need to refresh both tabs in order to get the correct number of issues
    func updateCircle(_ issuesNumber: Int, _ openOnly: Bool)
    {
        if (openOnly) { self.openIssues = issuesNumber }
        else { self.allIssues = issuesNumber }
        print("Update Called, open:\(self.openIssues), all: \(self.allIssues)")
        status.settings(self.openIssues, self.allIssues)
    }
}
