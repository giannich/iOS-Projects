//
//  BookmarkCell.swift
//  DuckDuckGo
//
//  Created by Gianni Chen on 2/18/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class BookmarkCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This function is what actually creates the images and labels
    func settings(_ URL: String)
    {
        // Creates a UILabel for the URL
        let cellURLLabel:UILabel = UILabel(frame: CGRect(x: 5, y: 5, width: 300, height: 25))
        cellURLLabel.text = URL
        cellURLLabel.textColor = UIColor.black
        cellURLLabel.backgroundColor = UIColor.clear
        cellURLLabel.textAlignment = NSTextAlignment.left
        self.addSubview(cellURLLabel)
    }
}
