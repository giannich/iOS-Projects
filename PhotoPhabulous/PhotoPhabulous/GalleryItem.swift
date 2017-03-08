//
//  GalleryItem.swift
//  PhotoPhabulous
//
//  Created by Gianni Chen on 2/25/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class GalleryItem
{
    var galleryImage: UIImage
    
    init(_ initImage: UIImage)
    {
        print("saved image")
        self.galleryImage = initImage
    }
}
