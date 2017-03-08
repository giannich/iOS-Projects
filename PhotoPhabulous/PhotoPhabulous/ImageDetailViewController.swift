//
//  ImageDetailViewController.swift
//  PhotoPhabulous
//
//  Created by Gianni Chen on 2/25/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit
import Social

class ImageDetailViewController: UIViewController {
    
    @IBOutlet var itemImageView: UIImageView!
    var passedImage: UIImage?
    
    // Sets the image to load
    func setImage(_ galleryItemImage: UIImage)
    {
        passedImage = galleryItemImage
    }
    
    // Actually loads the image after the view loads, otherwise there is no itemImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Navbar stuff
        self.navigationItem.title = "Detailed Image"
        let twtrImage: UIImage = UIImage.init(named: "twitterImage")!
        let shareButton: UIBarButtonItem = UIBarButtonItem.init(image: twtrImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ImageDetailViewController.shareOnTwitter))
        self.navigationItem.rightBarButtonItem = shareButton
        
        // Sets the image here
        itemImageView.image = passedImage
        
        /// Attribution - http://stackoverflow.com/questions/27880607/how-to-assign-an-action-for-uiimageview-object-in-swift
        // Enables taps
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        itemImageView.isUserInteractionEnabled = true
        itemImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Function that happens when the image is tapped
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // Hides the nav bar if it is not hidden, otherwise unhides it
        if (self.navigationController!.isNavigationBarHidden)
        {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            itemImageView.backgroundColor = UIColor.white
        }
        else
        {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            itemImageView.backgroundColor = UIColor.black
        }
        
    }
    
    /// Attribution - https://www.hackingwithswift.com/example-code/uikit/how-to-share-content-with-the-social-framework-and-slcomposeviewcontroller
    // Shares an image on Twitter, note that you need an account set up on the phone...
    func shareOnTwitter()
    {
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            vc.setInitialText("#twitter #socialmedia #noFilter #noPoopEmoji #camelCase #imBasicAsFuck 😂😂😂 😜😜😜")
            vc.add(passedImage)
            present(vc, animated: true)
        }
    }
}
