//
//  IssueCell.swift
//  GithubApp
//
//  Created by Gianni Chen on 2/5/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class IssueCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This function is what actually creates the images and labels
    func settings(_ title: String, _ username: String, _ date: String, _ open: Bool)
    {
        // Creates a UIImageView with an if/else statement to determine whether to load the open or closed icon
        let cellImageView:UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 25, width: 50, height: 50))
        let cellImage:UIImage
        if  (open) { cellImage = UIImage.init(named: "OpenIcon")! }
        else { cellImage = UIImage.init(named: "ClosedIcon")! }
        cellImageView.image = cellImage
        self.addSubview(cellImageView)
    
        // Creates a UILabel for the Title
        let cellTitleLabel:UILabel = UILabel(frame: CGRect(x: 80, y: 25, width: 250, height: 30))
        cellTitleLabel.text = title
        cellTitleLabel.textColor = UIColor.black
        cellTitleLabel.textAlignment = NSTextAlignment.left
        self.addSubview(cellTitleLabel)
    
        // Creates a UILabel for the Username
        let cellUserLabel:UILabel = UILabel(frame: CGRect(x: 80, y: 60, width: 100, height: 20))
        cellUserLabel.text = username
        cellUserLabel.textColor = UIColor.black
        cellUserLabel.font = UIFont(name: cellUserLabel.font.fontName, size: 12)
        cellUserLabel.textAlignment = NSTextAlignment.left
        self.addSubview(cellUserLabel)
    
        // Creates a UILabel for the Date
        let cellIssueDate:UILabel = UILabel(frame: CGRect(x: 200, y: 60, width: 100, height: 20))
        cellIssueDate.text = date
        cellIssueDate.textColor = UIColor.black
        cellIssueDate.font = UIFont(name: cellIssueDate.font.fontName, size: 12)
        cellIssueDate.textAlignment = NSTextAlignment.right
        self.addSubview(cellIssueDate)
    
        // Creates a Button for navigation
        let expandImage:UIImage = UIImage.init(named: "ArrowIcon")!
        let expandCellButton:UIButton = UIButton(frame: CGRect(x: 305, y: 15, width: 70, height: 70))
        expandCellButton.setImage(expandImage, for: UIControlState.normal)
        self.addSubview(expandCellButton)
    }
}
