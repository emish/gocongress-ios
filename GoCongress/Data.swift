//
//  Data.swift
//  GoCongress
//
//  Created by emish on 7/31/16.
//  Copyright © 2016 emish. All rights reserved.
//

import Foundation

/// Singleton Data class for storing all the data used by the application.
class Data {
    /// Accessor for all the data used in this application.
    static var sharedData = Data()
    /// Array of sessions in date order.
    var sessions: [Session]
    /// The currently active user.
    var user: User
    /// The name of the file used to parse sessions from (expecting .csv at the end).
    let filename = "congress_schedule"

    /// The parser that collects information from the Go Congress news blog.
    let feedParser: RSSParser

    fileprivate init() {
        var sessionParser = SessionParser(filename: self.filename)
        self.sessions = sessionParser.parse()

        // Right now we make a new one cuz all we store are the favorites.
        self.user = User()

        if let storedFavorites = UserDefaults.standard.object(forKey: "userFavorites") as? Foundation.Data {
            self.user.favorites = NSKeyedUnarchiver.unarchiveObject(with: storedFavorites) as! [Session]
        }

        self.feedParser = RSSParser()
    }

    /// Save whatever is necessary to the local user defaults.
    func syncUserData() {
        // ℹ️ We need to user NSKeyedArchiver for the whole array because it contains non-plist types (that conform to NSCoding).
        let storedFavorites = NSKeyedArchiver.archivedData(withRootObject: self.user.favorites)
        UserDefaults.standard.set(storedFavorites, forKey: "userFavorites")
    }
}
