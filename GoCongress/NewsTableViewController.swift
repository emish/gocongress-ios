//
//  NewsTableViewController.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/23/16.
//  Copyright © 2016 emish. All rights reserved.
//

import UIKit
import WebKit

let NEWS_CELL_ID = "newsCellIdentifier"
let NEWS_DETAIL_VIEW_SEGUE_ID = "newsDetailViewSegueIdentifier"

// Tags of the subviews in the TableViewCell of this TableView
let TITLE_TAG = 1
let DESCRIPTION_TAG = 2

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var newsDescriptionWebView: UIWebView!
    @IBOutlet weak var dateLabel: UILabel!
}

class NewsTableViewController: UITableViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.sharedData.feedParser.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: NewsTableViewCell = tableView.dequeueReusableCellWithIdentifier(NEWS_CELL_ID, forIndexPath: indexPath) as! NewsTableViewCell

        let feedItem = Data.sharedData.feedParser.items[indexPath.row]

        print("Populating cell with feedItem: \(dump(feedItem))")

        cell.title.text = feedItem.title

        cell.dateLabel.text = feedItem.date?.simpleDateAndTimeString ?? "No Date."

        cell.newsDescriptionWebView.loadHTMLString(feedItem.content ?? "", baseURL: nil)
        cell.newsDescriptionWebView.scrollView.scrollEnabled = false
        cell.newsDescriptionWebView.delegate = self

        return cell
    }

    // MARK: - UIWebViewDelegate

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let URL = request.URL {
            if navigationType == .LinkClicked {
                UIApplication.sharedApplication().openURL(URL)
                return false
            }
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
