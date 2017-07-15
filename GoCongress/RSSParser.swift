//
//  RSSParser.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/22/16.
//  Copyright © 2016 emish. All rights reserved.
//

import Foundation
import MWFeedParser

let CONGRESS_RSS_FEED = "feed://live.gocongress.org/?feed=rss2"

class RSSParser: NSObject, MWFeedParserDelegate {

    var items = [MWFeedItem]()

    override init() {
        super.init()

        let feedURL: URL = URL(string: CONGRESS_RSS_FEED)!
        let feedParser: MWFeedParser = MWFeedParser(feedURL: feedURL)

        // Configure and begin parsing.
        feedParser.delegate = self
        feedParser.feedParseType = ParseTypeFull
        feedParser.connectionType = ConnectionTypeAsynchronously
        feedParser.parse()
    }

    func feedParserDidStart(_ parser: MWFeedParser) {
        print("Started parsing.")
    }

    func feedParserDidFinish(_ parser: MWFeedParser) {
        print("Finished parsing.")
    }

    func feedParser(_ parser: MWFeedParser, didFailWithError error: Error) {
        print("Failed parsing with error \(error).")
    }

    func feedParser(_ parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        print("Parsed a FeedInfo: \(info).")
    }

    func feedParser(_ parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        print("Parsed a FeedItem: \(item).")
        // TODO: Make sure this gets inserted in sorted order by date updated.
        if !self.items.contains(item) {
            self.items.append(item)
        }
    }
}

// FIXME: Decide if necessary
//extension MWFeedItem {
//    override public func isEqual(_ object: AnyObject?) -> Bool {
//        guard let someFeedItem = object as? MWFeedItem else {
//            fatalError("Cannot compare non-session object with Session object.")
//        }
//        return self.identifier == someFeedItem.identifier &&
//            self.title == someFeedItem.title &&
//            self.link == someFeedItem.link &&
//            self.date == someFeedItem.date &&
//            self.updated == someFeedItem.updated &&
//            self.summary == someFeedItem.summary &&
//            self.content == someFeedItem.content &&
//            self.author == someFeedItem.author
//    }
//}
