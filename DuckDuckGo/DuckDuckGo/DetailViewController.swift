//
//  DetailViewController.swift
//  DuckDuckGo
//
//  Created by Gianni Chen on 2/16/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

// DetailBookmarkDelegate protocol goes here
extension DetailViewController: DetailBookmarkDelegate {
    func bookmarkPassedURL(url: String) {
        detailItem = QueryItem.init(url, "Useless Description")
    }
}

class DetailViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIWebViewDelegate {
    
    // Default homepage
    let homePage: String = "https://www.duckduckgo.com"
    
    // Bookmark button outlet
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!

    // Webview outlet
    @IBOutlet weak var webView: UIWebView!
    
    // Popover stuff
    var popoverContent: BookmarkViewController?
    
    // Initializes an empty list of URLs
    var defaultsURLArray: [String] = []
    
    // Loading view and bookmarked image view
    var loadingView: UIActivityIndicatorView?
    var bookmarkedImageView: UIImageView?
    
    func configureView() {
        // Update the user interface for the detail item.
        
        // NOTE: WILL CRASH ON NON-PLUS DEVICES BECAUSE THEY CAN'T EVEN SHOW A DETAILVIEWCONTROLLER!
        if let urlString: String = detailItem?.URL
        {
            webView.loadRequest(URLRequest(url: URL(string: urlString)!))
            
            // Saves urlString as the last article
            let defaults = UserDefaults.standard
            defaults.set(urlString, forKey: "lastArticle")
            
            // Puts a Bookmarked Image
            if let urlArray: [String] = defaults.array(forKey: "bookmarked") as? [String]
            {
                if (urlArray.contains(urlString)) { favBookmark() }
                else { notFavBookmark() }
            }

        }
        else
        {
            webView.loadRequest(URLRequest(url: URL(string: homePage)!))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Sets up the delegate for webView
        webView.delegate = self
        
        // When it is first loaded, gets the bookmarked list and the last article from userDefaults
        let defaults = UserDefaults.standard
        if let urlArray = defaults.array(forKey: "bookmarked")
        {
            defaultsURLArray = urlArray as! [String]
        }
        if let lastArticle = defaults.string(forKey: "lastArticle")
        {
            detailItem = QueryItem.init(lastArticle, "Last Article")
        }
        
        // loadingView settings
        loadingView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        loadingView!.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        loadingView!.center.y = self.view.center.y
        loadingView!.backgroundColor = UIColor(white: 0, alpha: 0.85)
        loadingView!.hidesWhenStopped = true
        
        // This section here deals with the positioning of the loading UIView
        let device: UIDevice = UIDevice.current
        let mainScreen: UIScreen = UIScreen.main
        var screenBound: CGFloat = 0
        if (device.orientation.isPortrait)
        {
            screenBound = mainScreen.bounds.width
            loadingView!.center.x = screenBound / 2
        }
        else if (device.orientation.isLandscape)
        {
            screenBound = mainScreen.bounds.height
            loadingView!.center.x = screenBound / 2
        }
        
        // loadingLabel settings
        let loadingLabel: UILabel = UILabel.init()
        loadingLabel.frame = CGRect.init(x: 0, y: 70, width: 100, height: 20)
        loadingLabel.text = "Loading"
        loadingLabel.textColor = UIColor.white
        loadingLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        loadingLabel.textAlignment = NSTextAlignment.center
        loadingView!.addSubview(loadingLabel)
        
        self.view.addSubview(loadingView!)
        
        // Fav Image
        let bookmarkedImage: UIImage = UIImage.init(named: "BookmarkImage")!
        bookmarkedImageView = UIImageView.init(image: bookmarkedImage)
        bookmarkedImageView!.frame = CGRect.init(x: (screenBound * 0.85), y: 75, width: 50, height: 50)
        bookmarkedImageView!.backgroundColor = UIColor.clear
        self.view.addSubview(bookmarkedImageView!)
        
        // Finally call configure view
        self.configureView()
    }
    
    /// Attribution - http://stackoverflow.com/questions/29467424/networkactivityindicator-not-working
    // Webview Delegate stuff
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        // Makes the spinning activity indicator start
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Animates the wheel
        loadingView!.startAnimating()

        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        // Makes the spinning activity indicator end
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Stops the wheel animation
        loadingView!.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: QueryItem? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    // Adds this url to the bookmarks
    @IBAction func favoriteThisPage() {
        if let safeURL = detailItem?.URL
        {
            // Appends a new url to the list
            defaultsURLArray.append(safeURL)
            
            // And updates the userDefaults
            let defaults = UserDefaults.standard
            defaults.set(defaultsURLArray, forKey: "bookmarked")
        }
    }
    
    /// Attribution - http://stackoverflow.com/questions/28224059/dismiss-popover-after-touch
    // I've tried to do it by myself using storyboard, but I can't seem to figure out how to dismiss the popover
    // NOTE: DUE TO SMALLER SCREEN REAL ESTATE, IPHONE BOOKMARKS DO NOT POPOVER FROM ANCHORS
    @IBAction func showPopover(sender: AnyObject) {
        
        popoverContent = (self.storyboard?.instantiateViewController(withIdentifier: "BookmarkViewController"))! as? BookmarkViewController
        popoverContent!.modalPresentationStyle = UIModalPresentationStyle.popover

        
        // Sets self as the delegate for running the protocol
        popoverContent?.delegate = self
       
        let popover = popoverContent!.popoverPresentationController
        popoverContent!.preferredContentSize = CGSize.init(width: 500, height: 500)
        popover!.delegate = self
        popover!.barButtonItem = bookmarkButton
        self.present(popoverContent!, animated: true, completion: nil)
    }

    // Handles bookmark imageview's alpha
    func favBookmark() {
        if let bookmarkIV = bookmarkedImageView {
            bookmarkIV.alpha = 1
            self.view.bringSubview(toFront: bookmarkIV)
        }
    }
    
    func notFavBookmark() {
        if let bookmarkIV = bookmarkedImageView
        {
            bookmarkIV.alpha = 0
            self.view.sendSubview(toBack: bookmarkIV)
        }
    }
}

