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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        refreshControl.addTarget(self, action: Selector("request"), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Table View Controller
extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row] as MWFeedItem
        cell.textLabel?.text = item.title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ArticleCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
}

// MARK: RSS Parser
extension ArticleListViewController: MWFeedParserDelegate {
    func request() {
        let URL = NSURL(string: "http://www.caracaschronicles.com/feed/rss2")
        let feedParser = MWFeedParser(feedURL: URL);
        feedParser.delegate = self
        feedParser.parse()
    }
    
    func feedParserDidStart(parser: MWFeedParser) {
        SVProgressHUD.show()
        items = [MWFeedItem]()
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        SVProgressHUD.dismiss()
        self.refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        print(info)
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        print(item)
        items.append(item)
    }
    
}