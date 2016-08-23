//
//  RSSParser.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/22/16.
//  Copyright © 2016 emish. All rights reserved.
//

import Foundation
import RSSKit

let CONGRESS_RSS_FEED = "feed://live.gocongress.org/?feed=rss2"

class RSSParser: RSSFeedParserDelegate {

    init() {
        let feedURL: NSURL = NSURL(string: CONGRESS_RSS_FEED)!
        let feedParser: RSSFeedParser = RSSFeedParser(feedURL: feedURL)

        feedParser.delegate = self
        feedParser.feedParseType = .Full

        feedParser.connectionType = .Asynchronously

        feedParser.parse()
    }

    @objc func feedParserDidStart(parser: RSSFeedParser) {
        print("Started parsing.")
    }

    @objc func feedParserDidFinish(parser: RSSFeedParser) {
        print("Finished parsing.")
    }

    @objc func feedParser(parser: RSSFeedParser, didFailWithError error: NSError) {
        print("Failed parsing with error \(error).")
    }

    @objc func feedParser(parser: RSSFeedParser, didParseFeedInfo info: RSSFeedInfo) {
        print("Parsed a FeedInfo: \(info).")
    }

    @objc func feedParser(parser: RSSFeedParser, didParseFeedItem item: RSSFeedItem) {
        print("Parsed a FeedItem: \(item).")
    }
}

extension RSSFeedItem {
    override public func isEqual(object: AnyObject?) -> Bool {
        guard let someFeedItem = object as? RSSFeedItem else {
            fatalError("Cannot compare non-session object with Session object.")
        }
        return self.identifier == someFeedItem.identifier &&
            self.title == someFeedItem.title &&
            self.link == someFeedItem.link &&
            self.date == someFeedItem.date &&
            self.updated == someFeedItem.updated &&
            self.summary == someFeedItem.summary &&
            self.content == someFeedItem.content &&
            self.author == someFeedItem.author
    }
}
