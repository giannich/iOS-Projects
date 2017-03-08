Contents:

PhotoPhabulous
|--AppDelegate.swift 				(default file)
|--GalleryItem.swift 				(gallery item class)
|--ImageDetailViewController.swift	(image detail view controller)
|--ItemCollectionViewCell.swift		(collection view cell class)
`--ViewController.swift				(main viewcontroller)

What works:
- I think everything is working this time...
- I got the disappearing nav bar!
- There should be an alert in case of no internet, unlike last time, HTTPURLResponse is tested for nil in a another function that catches the error

What doesn't work:
- Nothing happens when the use chooses the camera option, I can't really test it on the simulator
- I haven't tested the twitter posting part since I don't have a twitter account, hopefully it's all handled by the Social framework
- The address "http://stachesandglasses.appspot.com/post/giannich/" returns a 405 method not found error, so I could only upload the photos on the default user on "http://stachesandglasses.appspot.com/", all the images that are downloaded are therefore scraped from "http://stachesandglasses.appspot.com/user/default/web/"

Notes:
- It takes some time for the collection view to create the GalleryItems and to load up the images even after downloading them, so give it a couple of seconds after the activity indicator is gone
- The do-try-catch statement only has the do and catch keywords, the catch also catches every type of error, but we only throw the no internet connection error here
- NSCache will cache your images, but it just releases them after you close the app, so it's kinda useless unless you want to have multiple networking sessions in one go