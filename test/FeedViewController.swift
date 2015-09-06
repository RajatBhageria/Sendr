
import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var feedItems: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.sendSubviewToBack(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchNewItems()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        fetchNewItems()
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        refreshControl.endRefreshing()
    }
    
    func fetchNewItems() {
        var query = PFQuery(className:"RentFeed")
        query.orderByAscending("toDate")
        //        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    self.feedItems = objects
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of sections.
        if (feedItems != nil) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.tableView.backgroundView = nil
            return feedItems!.count
        } else {
            // Display a message when the table is empty
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            
            messageLabel.text = "No data is currently available. Please pull down to refresh."
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = UIFont(name: "Avenir-Light", size: 20)
            messageLabel.sizeToFit()
            
            self.tableView.backgroundView = messageLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("feedItemCell") as! UITableViewCell
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let priceLabel = cell.viewWithTag(2) as! UILabel
        let item = feedItems![indexPath.row]
        titleLabel.text = (item["title"]! as! String)
        if let price = item["price"] {
            priceLabel.text = "$\(price)"
        } else {
            priceLabel.text = ""
        }
        
        if indexPath.row % 2 != 0 {
            cell.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detailItemSegue", sender: self)
        println("You selected cell #\(indexPath.row)!")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailItemSegue" {
            var yourNextViewController = (segue.destinationViewController as! DetailViewController)
            yourNextViewController.feedItem = feedItems![tableView.indexPathForSelectedRow()!.row]
        }
    }
}
