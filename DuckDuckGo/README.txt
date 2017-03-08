Contents:

DuckDuckGo
|--AppDelegate.swift 				(default file)
|--BookmarkCell.swift 				(bookmark cell template)
|--BookmarkViewController.swift		(main bookmark viewcontroller)
|--DetailBookmarkDelegate.swift		(detail viewcontroller and bookmark viewcontroller protocol)
|--DetailViewController.swift		(main detail viewcontroller)
|--MasterViewController.swift		(main master viewcontroller)
|--QueryCell.swift					(query cell template)
`--QueryItem.swift					(query item class)

What works:
- Almost Everything

What doesn't work:
- I can't get the edit button to do its job

Notes:
- Since the detailview never appears on a non-plus size iphone, a certain line of code will not run, thereby leading to a premature-crash
- I tested the app on an ipad-pro and on an iphone 7 plus, which are the only devices that support a splitview to begin with
- There is a compiler warning about prototype cells, and I've tried everything to shut it down, but it still stays there...


ANOTHER NOTE:
- Will upload the 1 page final proposal pdf tomorrow morning/afternoon