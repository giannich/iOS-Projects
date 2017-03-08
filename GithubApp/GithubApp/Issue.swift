//
//  Issue.swift
//  GithubApp
//
//  Created by Gianni Chen on 2/5/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

class Issue {
    
    let title: String
    let username: String
    let date: String
    let open: Bool
    let url: String
    
    init(_ title: String, _ username: String, _ date: String, _ open: Bool, _ url: String)
    {
        self.title = title
        self.username = username
        self.date = date
        self.open = open
        self.url = url
    }
}
