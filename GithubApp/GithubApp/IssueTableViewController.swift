//
//  ViewController.swift
//  GithubApp
//
//  Created by Gianni Chen on 2/5/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class IssueTableViewController: UITableViewController {
    
    // Declares the tableview and the array
    var issues: [Issue] = []
    var creator: ViewController? = nil
    var pullOnlyOpen: Bool = false
    var urlString: String = "https://api.github.com/repos/uchicago-mobi/mpcs51030-2017-winter-forum/issues?state=all"
    var issuesNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calls to update the JSON for the first time
        self.updateData()
        
        /// Attribution - http://blog.luduscella.com/uitableview/how-to-implement-uitableview-programmatically-using-swift
        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // RefreshControl management
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector (refreshTable), for: UIControlEvents.valueChanged)
        
        print("Table finished loading")
    }
    
    // Returns the number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return issues.count
    }
    
    // Handles the cell type and its location
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:IssueCell = IssueCell.init(frame: CGRect(x: 0, y: (indexPath.row * 100), width: 375, height: 100))
        cell.settings(issues[indexPath.row].title, issues[indexPath.row].username, issues[indexPath.row].date, issues[indexPath.row].open)
        return cell;
    }
    
    // Handles each cell's height
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (CGFloat.init(100))
    }
    
    // Gets called whenever a cell is highlighted -> creates a new detailView on the navigator
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        // The creator here is whoever called the whoCreatedMe function below
        creator?.loadDetail(issues[indexPath.row].title, issues[indexPath.row].username, issues[indexPath.row].date, issues[indexPath.row].open, pullOnlyOpen, issues[indexPath.row].url)
    }
    
    // This function is useful in determining who created this tableview
    func whoCreatedMe(_ creator: ViewController)
    {
        self.creator = creator
    }
    
    // This is used to determine whether to pull all the issues or just the open ones, by default it pulls everything
    func pullOnlyOpenIssues(_ status: Bool)
    {
        // Sets this variable to status, so we can keep track of who called what
        self.pullOnlyOpen = status
        
        // Changes the urls depending on whether we want only the open issues or all of them
        if (status)
        {
            urlString = "https://api.github.com/repos/uchicago-mobi/mpcs51030-2017-winter-forum/issues?state=open"
        }
        else
        {
            urlString = "https://api.github.com/repos/uchicago-mobi/mpcs51030-2017-winter-forum/issues?state=all"
        }
    }
    
    // Simply appends the data into the issues array
    func appendData(_ title: String, _ username: String, _ date: String, _ open: Bool, _ url: String)
    {
        issues.append(Issue.init(title, username, date, open, url))
    }
    
    /// Attribution - https://www.andrewcbancroft.com/2015/03/17/basics-of-pull-to-refresh-for-swift-developers/
    // This is the simple refreshTable function that calles the updateData() function
    func refreshTable(refreshControl: UIRefreshControl)
    {
        // It first removes all the current issues and newly appends all the issues
        print("Updating Data")
        issues.removeAll()
        issuesNumber = 0
        self.updateData()
        self.tableView.reloadData()
        
        // It then updates the circle view numbers
        // We are using issuesNumber instead of issues.count because the latter somehow always returns 0
        self.creator?.updateCircle(issuesNumber, pullOnlyOpen)
        refreshControl.endRefreshing()
    }
    
    /// Attribution - http://www.learnswiftonline.com/mini-tutorials/how-to-download-and-read-json/
    public func updateData()
    {
        // This bunch of code below just requests the JSON data through HTTP
        // It then parses through the JSON and appends the data onto the issues array
        print("Started HTTP Request")
        let requestURL: NSURL = NSURL(string: urlString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest)
        {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200)
            {
                print("Started Reading JSON")
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let jsonIssueArray = json as? [[String: AnyObject]]
                {
                    // For every issue
                    for jsonIssue in jsonIssueArray
                    {
                        // Initializes variables
                        var title: String = ""
                        var username: String = ""
                        var date: String = ""
                        var open: Bool = false
                        var url: String = ""
                        
                        // inFormatter is the API's string format, outFormatter is what we want
                        let inFormatter = DateFormatter()
                        inFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                        let outFormatter = DateFormatter()
                        outFormatter.dateFormat = "MMM dd, yyyy"
                        
                        // Find the title, login id, and date
                        for (key, value) in jsonIssue
                        {
                            // Url
                            if (key == "html_url")
                            {
                                url = value as! String
                            }
                            
                            // Title
                            if (key == "title")
                            {
                                title = value as! String
                            }
                            
                            // User is actually another dictionary, so we do the same process to find the login id
                            if (key == "user")
                            {
                                for (userKey, userValue) in value as! [String: AnyObject]
                                {
                                    if (userKey == "login")
                                    {
                                        username = userValue as! String
                                    }
                                }
                            }
                            
                            // No need to check if it is closed since open is set to false on default
                            if (key == "state")
                            {
                                if (value as! String == "open")
                                {
                                    open = true
                                }
                            }
                            
                            // It first transforms the String into a dateObject, and then from dateObject to String again
                            if (key == "created_at")
                            {
                                let dateObject = inFormatter.date(from: value as! String)
                                date = outFormatter.string(from: dateObject!)
                            }
                        }
                        
                        // At the end of the day, we append the data into the issues array
                        self.appendData(title, username, date, open, url)
                        self.issuesNumber += 1
                    }
                }
            }
            // We reload the data as soon as we finish looking through the JSON
            // This means that the tableview loads before the data is even loaded onto the issues array
            self.tableView.reloadData()
            self.creator?.updateCircle(self.issuesNumber, self.pullOnlyOpen)
            print("Finished Reading JSON")
            
        }
        task.resume()
    }
}
