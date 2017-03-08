//
//  QueryItem.swift
//  DuckDuckGo
//
//  Created by Gianni Chen on 2/18/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

class QueryItem {
    
    let URL: String
    let description: String
    
    init(_ URL: String, _ description: String)
    {
        self.URL = URL
        self.description = description
    }
}
