//
//  MasterViewController.swift
//  DuckDuckGo
//
//  Created by Gianni Chen on 2/16/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    var results: [QueryItem] = []
    var resultNum: Int = 0
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Creates the duckRed color
    let duckRed: UIColor = UIColor.init(red: 222/255, green: 88/255, blue: 51/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Sets up the navigation controller stuff
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        //self.navigationItem.rightBarButtonItem = addButton
        
        // Searchbar configuration
        searchBar.placeholder = "Insert your query here"
        searchBar.showsCancelButton = true
        searchBar.delegate = self

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // When it is first loaded, gets the last query from userDefaults
        let defaults = UserDefaults.standard
        if let standardQuery = defaults.string(forKey: "lastQuery")
        {
            queryData(standardQuery)
        }
        else
        {
            queryData("apple")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Verify we are using the correct segue
        if segue.identifier == "showDetail" {
            
            // Get the index for the selected row
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // Retrieve the object from the data array
                let object = results[indexPath.row] 
                
                // Navigate the hierarchy to find the detail view controller
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                // Set the detail view controller's detailItem property
                controller.detailItem = object
                
                // Set the bar button appropriately
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                
                // Show the back button on the compact size
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // Gets called whenever a cell is highlighted -> creates a new detailView on the navigator
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        // Retrieve the object from the data array
        let object = results[indexPath.row]
        
        // Navigate the hierarchy to find the detail view controller
        let controller = detailViewController!
        
        // Set the detail view controller's detailItem property
        controller.detailItem = object
        
        // Set the bar button appropriately
        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        
        // Show the back button on the compact size
        controller.navigationItem.leftItemsSupplementBackButton = true
    }
    
    // MARK: - Search Bar
    
    // Runs when the user clicks on the button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.clearQueryData()
        
        if let query = searchBar.text
        {
            queryData(query)
            
            // Saves query as the last query in userDefaults
            let defaults = UserDefaults.standard
            defaults.set(query, forKey: "lastQuery")
        }
    }
    
    // Clears the results from the previous query
    func clearQueryData() {
        results.removeAll()
        resultNum = 0
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    // Handles cell type and its location
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = object.description
        return cell
        */
        
        let cell: QueryCell = QueryCell.init(frame: CGRect(x: 0, y: (indexPath.row * 100), width: 320, height: 100))
        cell.settings(results[indexPath.row].URL, results[indexPath.row].description)
        return cell;
    }
    
    // Handles each cell's height
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (CGFloat.init(80))
    }
    
    // MARK: - JSON Stuff

    /// Attribution - http://www.learnswiftonline.com/mini-tutorials/how-to-download-and-read-json/
    public func queryData(_ queryValue: String)
    {
        // This bunch of code below just requests the JSON data through HTTP
        // It then parses through the JSON and appends the data onto the issues array
        print("Started HTTP Request")
        
        let queryString: String = "http://api.duckduckgo.com/?q=" + queryValue + "&format=json&pretty=1"
        let requestURL: NSURL = NSURL(string: queryString)!
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
                //print(json!)
                if let jsonResultArray = json as? [String: AnyObject]
                {
                    // Iterates through the jsonResultArray
                    for (key, value) in jsonResultArray as [String: AnyObject]
                    {
                        // Looks for the RelatedTopics field
                        if (key == "RelatedTopics")
                        {
                            // Casts the value of RelatedTopics as a list of String:AnyObject dict (2d array)
                            if let relatedVal = value as? [[String: AnyObject]]
                            {
                                // Goes through the list of relatedVal, in this case, topic is [String:AnyObject] (1d array)
                                for topic in relatedVal
                                {
                                    // Here we initialize the information for every related topic
                                    var URL: String = ""
                                    var description: String = ""
                                    
                                    // For each of the topics, looks for FirstURL and Text in the its field
                                    for (topicKey, topicVal) in topic as [String: AnyObject]
                                    {
                                        if (topicKey == "FirstURL")
                                        {
                                            URL = topicVal as! String
                                        }
                                        
                                        if (topicKey == "Text")
                                        {
                                            description = topicVal as! String
                                        }
                                    }
                                    
                                    // For each actual topic, append it to the list
                                    if (URL != "" && description != "")
                                    {
                                        self.appendData(URL, description)
                                        self.resultNum += 1
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                // Creates an instance of an alert and an instance of action with the above title, message, and button text
                let alert = UIAlertController(title: "No Response", message: "The application failed to get the data", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                // Attaches the action action to alert and then displays it
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
            self.tableView.reloadData()
            print("Finished Reading JSON")
            
        }
        task.resume()
    }
    
    // Simply appends the data into the issues array
    func appendData(_ URL: String, _ description: String)
    {
        results.append(QueryItem.init(URL, description))
    }
}

