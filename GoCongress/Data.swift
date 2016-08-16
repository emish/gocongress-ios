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

    private init() {
        var parser = SessionParser(filename: self.filename)
        self.sessions = parser.parse()

        // TODO: Init user from defaults if found.
        // else
        self.user = User()
    }

    /// Save whatever is necessary to the local user defaults.
    func syncUserData() {
        //NSUserDefaults.standardUserDefaults().setObject(data, forKey: "user")
    }
}
