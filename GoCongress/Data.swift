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
    static var data = Data()
    
    let filename = "congress_schedule"
    
    var sessions = [Session]()
    
    private init() {
    }
}