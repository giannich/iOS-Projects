//
//  ViewController.swift
//  PhotoPhabulous
//
//  Created by Gianni Chen on 2/25/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit
import Foundation

/// Attribution - http://swiftiostutorials.com/tutorial-using-uicollectionview-uicollectionviewflowlayout/
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    // Initialize values
    var appendList: [String] = []
    var galleryItems: [GalleryItem] = []
    var imagePicker = UIImagePickerController()
    let SharedNetworking = URLSession.shared
    let cache = NSCache<NSString, UIImage>()
    var loadingView: UIActivityIndicatorView?
    
    // Error Enums
    enum NetworkError: Error {
        case noInternet
        case otherError
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the loadingView and animates the wheel, it will stop animating after the asynchronous call in queryData() has ended
        loadingViewSetup()
        loadingView!.startAnimating()
        
        // Query data
        queryData()
        
        // Button stuff
        let pickButton: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.camera, target: self, action: #selector(ViewController.chooseImageMode))
        self.navigationItem.rightBarButtonItem = pickButton
    }
    
    func loadingViewSetup()
    {
        // loadingView settings
        loadingView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        loadingView!.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        loadingView!.center.y = self.view.center.y
        loadingView!.backgroundColor = UIColor(white: 0, alpha: 0.85)
        loadingView!.hidesWhenStopped = true
        
        // This section here deals with the positioning of the loading UIView
        let device: UIDevice = UIDevice.current
        let mainScreen: UIScreen = UIScreen.main
        var widthBound: CGFloat = 0
        var lengthBound: CGFloat = 0
        if (device.orientation.isPortrait)
        {
            widthBound = mainScreen.bounds.width
            lengthBound = mainScreen.bounds.height
            loadingView!.center.x = widthBound / 2
            loadingView!.center.y = lengthBound / 2
        }
        else if (device.orientation.isLandscape)
        {
            widthBound = mainScreen.bounds.height
            lengthBound = mainScreen.bounds.width
            loadingView!.center.x = widthBound / 2
            loadingView!.center.y = lengthBound / 2
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
    }
    
    /// Attribution - https://www.hackingwithswift.com/example-code/system/how-to-cache-data-using-nscache
    // Appends the data onto galleryItems from cache or online
    // Kinda useless since the cache is not saved between sessions...
    func appendData()
    {
        print("Appending Data")
        for imageURL in appendList
        {
            // Sets up variables
            var tempImage: UIImage
        
            // If the object exists in cache, use that
            if let cachedVersion = cache.object(forKey: imageURL as NSString)
            {
                tempImage = cachedVersion
            }
                // Otherwise download the image and cache it
            else
            {
                let url = URL(string: imageURL)
                let data = try? Data(contentsOf: url!)
                tempImage = UIImage(data: data!)!
            
                cache.setObject(tempImage, forKey: imageURL as NSString)
            }
        
            // Finally, create the object
            galleryItems.append(GalleryItem.init(tempImage))
        }
    }
    
    /// Attribution - http://stackoverflow.com/questions/24195310/how-to-add-an-action-to-a-uialertview-button-using-swift-ios
    // Prompts the user for which mode to pick their image
    func chooseImageMode()
    {
        let alert = UIAlertController(title: "Select Source", message: "Please select the photo source", preferredStyle: .alert)
        
        // Selects photos from the camera
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { cameraAction in self.chooseImage(true)})
        // Selects photos from the user's photo library
        let libraryAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.default, handler: { cameraAction in self.chooseImage(false)})

        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Attribution - http://stackoverflow.com/questions/24625687/swift-uiimagepickercontroller-how-to-use-it
    // Allows the user to choose an image from their camera or photo stream
    func chooseImage(_ isCamera: Bool)
    {
        // NOTE: The simulator doesn't support a camera, so I'm not sure how it is handled here...
        if (isCamera)
        {
            print("Camera chosen")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = false
            
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        else
        {
            print("Library chosen")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
            {
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    /// Attribution - http://stackoverflow.com/questions/39009889/xcode-8-creating-an-image-format-with-an-unknown-type-is-an-error
    // Function is called when user finishes picking image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        // If an image was picked, it would append it to the galleryItems and then reload the collectionView
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            galleryItems.append(GalleryItem.init(pickedImage))
        }
        
        collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)

    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        cell.setGalleryItem(galleryItems[indexPath.row])
        return cell
        
    }
    
    /// Attribution - https://www.codebeaulieu.com/29/prepareForSegue
    // Segues into ImageDetailViewController, and passes the galleryItem
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ImageDetailSegue"
        {
            if let destination = segue.destination as? ImageDetailViewController
            {
                if let indexPath = self.collectionView.indexPathsForSelectedItems?[0]
                {
                    destination.setImage(galleryItems[indexPath.row].galleryImage)
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    // Nothing happens here since we take care of that in prepare for segue function
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width / 4.0
        return CGSize(width: picDimension, height: picDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
    
    // MARK: - JSON Stuff
    
    /// Attribution - http://www.learnswiftonline.com/mini-tutorials/how-to-download-and-read-json/
    public func queryData()
    {
        // This bunch of code below just requests the JSON data through HTTP
        // It then parses through the JSON and appends the data onto the issues array
        print("Started HTTP Request")
        
        let queryString: String = "https://stachesandglasses.appspot.com/user/default/json/"
        let requestURL: NSURL = NSURL(string: queryString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        
        // This closure below is asynchronous, so all of this happens kinda in the background
        let task = SharedNetworking.dataTask(with: urlRequest as URLRequest)
        {
            (data, response, error) -> Void in
            
            // Will execute if and only if response is not null, otherwise an alert pops up
            if (self.tryOutError(response))
            {
                //let httpResponse: HTTPURLResponse = try self.tryOutError(response)!
                let httpResponse: HTTPURLResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
            
                if (statusCode == 200)
                {
                    print("Started Reading JSON")
                    // Makes the spinning activity indicator start
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])

                    if let jsonResultArray = json as? [String: AnyObject]
                    {
                        // Iterates through the jsonResultArray
                        for (key, value) in jsonResultArray as [String: AnyObject]
                        {
                            // Looks for the results field
                            if (key == "results")
                            {
                                // Gets the results array
                                if let resultList = value as? [[String: AnyObject]]
                                {
                                    // Each ImageData is an entry
                                    for imageData in resultList
                                    {
                                        // Initializes base imageURL
                                        var imageURL: String = "https://stachesandglasses.appspot.com/"
                                    
                                        // Looks for the image url from the keys
                                        for (imageKey, imageVal) in imageData as [String: AnyObject]
                                        {
                                            if (imageKey == "image_url")
                                            {
                                                imageURL += imageVal as! String
                                            }
                                        }
                                    
                                        // For each actual topic, append it to the list
                                        if (imageURL != "https://stachesandglasses.appspot.com/")
                                        {
                                            self.appendList.append(imageURL)
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
                    let alert = UIAlertController(title: "Bad Response", message: "The application failed to get the data",preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                    // Attaches the action action to alert and then displays it
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            // This error is printed in the even of no internet connection since HTTPResponse is nil
            else
            {
                // Creates an instance of an alert and an instance of action with the above title, message, and button text
                let alert = UIAlertController(title: "No Response", message: "It seems like there is no internet connection",preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                // Attaches the action action to alert and then displays it
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
            // Appends the data, reloads the view, and takes care of the loading animations
            // This happens regardless of error or no error
            print("Finished Reading JSON")
            self.appendData()
            self.loadingView!.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.collectionView.backgroundColor = UIColor.black
            self.collectionView.reloadData()
            print("Finished loading images")
        }
        task.resume()
    }
    
    // Error handling here for the sake of grades!
    func tryOutError(_ response: AnyObject?) -> Bool
    {
        let errorResponse: HTTPURLResponse? = nil
        
        do
        {
            // If response is not nil, will return true, otherwise throws an error
            guard errorResponse != response as! HTTPURLResponse? else {throw NetworkError.noInternet }
            return true
        }
        // Will catch any error here, and will return false
        catch
        {
            // Response nil
            print("Response is null")
            return false
        }
    }
}
