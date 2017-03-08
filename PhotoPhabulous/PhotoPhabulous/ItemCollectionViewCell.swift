//
//  ItemCollectionViewCell.swift
//  PhotoPhabulous
//
//  Created by Gianni Chen on 2/25/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var itemImageView: UIImageView!
    
    func setGalleryItem(_ item: GalleryItem)
    {
        itemImageView.image = item.galleryImage
    }
    
}
