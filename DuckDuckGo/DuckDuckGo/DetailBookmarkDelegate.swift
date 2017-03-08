//
//  DetailBookmarkDelegate.swift
//  DuckDuckGo
//
//  Created by Gianni Chen on 2/19/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

protocol DetailBookmarkDelegate: class {
    func bookmarkPassedURL(url: String) -> Void
}
