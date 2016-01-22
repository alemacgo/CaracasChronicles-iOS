//
//  ViewController.swift
//  CaracasChronicles-iOS
//
//  Created by Alejandro on 1/20/16.
//
//

import UIKit

class ArticleListViewController: UIViewController {

    var items = [MWFeedItem]()
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    let feedParser = MWFeedParser(feedURL: NSURL(string: Address.RSSFeed))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        refreshControl.addTarget(self, action: Selector("request"), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        feedParser.delegate = self
        request()
    }
    
    override func viewWillAppear(animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Table View Controller
extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row] as MWFeedItem
        cell.textLabel?.text = item.title
        cell.textLabel?.numberOfLines = 0
        
        fetchFirstNYTimesSquareImage(item.title)
        let imageURL = NSURL(string: "http://graphics8.nytimes.com/images/2011/11/23/us/23abortion_span/23abortion_span-thumbStandard.jpg")
        let placeholderImage = UIImage(named: "grayLogo")
        cell.imageView?.contentMode = .ScaleAspectFit
        cell.imageView?.setImageWithURL(imageURL!, placeholderImage: placeholderImage)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ArticleCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showArticle", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: RSS Parser
extension ArticleListViewController: MWFeedParserDelegate {
    func request() {
        // Prevent showing two loading indicators at once
        if !refreshControl.refreshing {
            SVProgressHUD.show()
        }
        feedParser.parse()
    }
    
    func feedParserDidStart(parser: MWFeedParser) {
        items = [MWFeedItem]()
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        SVProgressHUD.dismiss()
        self.refreshControl.endRefreshing()
        tableView.reloadData()
    }

    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        items.append(item)
    }
}

// MARK: Segues
extension ArticleListViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showArticle" {
            let item = self.items[tableView.indexPathForSelectedRow!.row] as MWFeedItem
            let destination = segue.destinationViewController as! ArticleViewController
            destination.title = item.title
            destination.URL = NSURL(string: item.link)
        }
    }
}