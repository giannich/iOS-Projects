ViewController Hierarchy:

ViewController: UITabBarController
|
|--navOpen: UINavigationController
| |
| |--open: IssueTableViewController
| `--detail: IssueDetailViewController
|
|--navAll: UINavigationController
| |
| |--all: IssueTableViewController
| `--detail: IssueDetailViewController
|
`--CircleViewController: UIViewCOntroller

What works:
- Almost everything

What doesn't work:
- You need to wait for everything to load and refresh before the first and second tab show up all the issues
- You can't open Safari by tapping the action button
- This is because I ran out of time...

Notes:
- Will update this README in a bit, class is starting...