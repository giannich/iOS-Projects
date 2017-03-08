//
//  BookmarkViewController.swift
//  DuckDuckGo
//
//  Created by Gianni Chen on 2/19/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class BookmarkViewController: UITableViewController {
    
    // Static variables that can be modified by the the caller of addBookmark
    var bookmarked: [String] = []
    
    // Sets up the delegate here
    weak var delegate: DetailBookmarkDelegate?
    
    // Creates the duckRed color
    let duckRed: UIColor = UIColor.init(red: 222/255, green: 88/255, blue: 51/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // When it is first loaded, gets the bookmarked from userDefaults
        let defaults = UserDefaults.standard
        if let urlArray = defaults.array(forKey: "bookmarked")
        {
            bookmarked = urlArray as! [String]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarked.count
    }
    
    // Makes the table editable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // More editing stuff
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            bookmarked.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // Handles cell type and its location
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: BookmarkCell = BookmarkCell.init(frame: CGRect(x: 0, y: (indexPath.row * 30), width: 500, height: 30))
        cell.settings(bookmarked[indexPath.row])
        return cell;
    }
    
    // Handles each cell's height
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (CGFloat.init(30))
    }
    
    // Gets called whenever a cell is highlighted -> creates a new detailView on the navigator
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        // Retrieve the object from the data array and pass it to the delegate
        delegate?.bookmarkPassedURL(url: bookmarked[indexPath.row])
        dismissPopover(sender: self)
    }
    
    /// Attribution - http://stackoverflow.com/questions/28224059/dismiss-popover-after-touch
    @IBAction func dismissPopover(sender: AnyObject) {
        let tmpController :UIViewController! = self.presentingViewController;
        self.dismiss(animated: true, completion: {()->Void in
            tmpController.dismiss(animated: true, completion: nil)
        })
    }
}
