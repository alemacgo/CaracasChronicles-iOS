//
//  ViewController.swift
//  CaracasChronicles-iOS
//
//  Created by Alejandro on 1/20/16.
//
//

import UIKit

class ArticleListViewController: UIViewController {

    var articles = [Article]()
    
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
    
    override func viewDidAppear(animated: Bool) {
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
        return articles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let article = articles[indexPath.row]
        cell.textLabel?.text = article.headline
        cell.textLabel?.numberOfLines = 0
        
        fetchFirstNYTimesSquareImage(article, indexPath: indexPath, completion: fetchImageAtIndexPath)
        
        cell.imageView?.contentMode = .ScaleAspectFit
        cell.imageView?.image = UIImage(named: "grayLogo")
    }
    
    func fetchImageAtIndexPath(indexPath: NSIndexPath) {
        let imageURL = articles[indexPath.row].thumbnailURL

        tableView.cellForRowAtIndexPath(indexPath)?.imageView?.setImageWithURL(imageURL!, placeholderImage: nil)
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
        articles = [Article]()
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        SVProgressHUD.dismiss()
        self.refreshControl.endRefreshing()
        tableView.reloadData()
    }

    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        articles.append(Article(headline: item.title!, URL: NSURL(string: item.link!)!))
    }
}

// MARK: Segues
extension ArticleListViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showArticle" {
            let article = self.articles[tableView.indexPathForSelectedRow!.row]
            let destination = segue.destinationViewController as! ArticleViewController
            destination.title = article.headline
            destination.URL = article.URL
        }
    }
}