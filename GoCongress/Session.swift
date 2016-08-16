//
//  Session.swift
//  GoCongress
//
//  Created by emish on 8/4/16.
//  Copyright © 2016 emish. All rights reserved.
//

import Foundation

class Session : NSObject, Comparable, NSCoding {
    let title: String
    let instructor: String
    let room: String
    let info: String
    let date: NSDate
    let timeStart: NSDate
    /// The time a session ends. May not exist.
    let timeEnd: NSDate?

    static let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!

    init(title: String, instructor: String, room: String, info: String, date: NSDate, timeStart: NSDate, timeEnd: NSDate?) {
        self.title = title
        self.instructor = instructor
        self.room = room
        self.info = info
        self.date = date
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObjectForKey("title") as? String,
            let instructor = aDecoder.decodeObjectForKey("instructor") as? String,
            let room = aDecoder.decodeObjectForKey("room") as? String,
            let info = aDecoder.decodeObjectForKey("info") as? String,
            let date = aDecoder.decodeObjectForKey("date") as? NSDate,
            let timeStart = aDecoder.decodeObjectForKey("timeStart") as? NSDate,
            let timeEnd = aDecoder.decodeObjectForKey("timeEnd") as? NSDate?
            else {
                return nil
        }

        self.init(
            title: title,
            instructor: instructor,
            room: room,
            info: info,
            date: date,
            timeStart: timeStart,
            timeEnd: timeEnd
        )
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.instructor, forKey: "instructor")
        aCoder.encodeObject(self.room, forKey: "room")
        aCoder.encodeObject(self.info, forKey: "info")
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject(self.timeStart, forKey: "timeStart")
        aCoder.encodeObject(self.timeEnd, forKey: "timeEnd")
    }

    override func isEqual(object: AnyObject?) -> Bool {
        guard let someSession = object as? Session else {
            fatalError("Cannot compare non-session object with Session object.")
        }
        return (self.timeStart == someSession.timeStart) &&
            (self.timeEnd == someSession.timeEnd) &&
            (self.title == someSession.title) &&
            (self.instructor == someSession.instructor) &&
            (self.room == someSession.room) &&
            (self.info == someSession.info)
    }

}


/// A session is ordered before another session if it's start time is earlier.
func <(sessionA: Session, sessionB: Session) -> Bool {
    return sessionA.timeStart.timeIntervalSince1970 < sessionB.timeStart.timeIntervalSince1970
}

/// Parses the USGO csv file creating Session objects.
struct SessionParser {
    
    let rawData: String
    let fullPath: String
    
    // TODO: Create NSTimeZone and parse times as EST or w/e they happen to be.
    let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    /// Parser internal state machine for progressing through the CSV.
    var currentDate: NSDate?
    var currentRoom: String?
    var currentStartTime: NSDate?
    var currentEndTime: NSDate?
    var currentTitle: String?
    var currentId: Int
    
    init(filename: String) {
        let bundle = NSBundle.mainBundle()
        self.fullPath = bundle.pathForResource(filename, ofType: "csv")!
        print("Filename loading: \(self.fullPath)")
        
        self.rawData = try! String(contentsOfFile: self.fullPath)
        print("Contents: \n --- \n\(self.rawData)\n---\n")

        self.currentId = 0
    }
    
    /// Parse the input CSV file that was configured in the initializer and return the list of Sessions generated.
    mutating func parse() -> [Session] {
        var sessions = [Session]()
        let rows = self.rawData.componentsSeparatedByString("\r\n")
        for (i, row) in rows.enumerate() {
            if i == 0 {
                // This is the header row
                continue
            }
            if let parsedSession = self.parseRow(row) {
                sessions.append(parsedSession)
            }
        }
        
        print("Diagnostics:")
        print("Number of cols = \(self.numberOfCols())")
        print("Sessions: \(sessions)")
        
        return sessions
    }
    
    /// Parse a single row.
    /// Notes: 
    ///    - Some rows may be emtpy thus return a nil Session.
    mutating func parseRow(row: String) -> Session? {
        let parts = row.componentsSeparatedByString(",")
        
        var allEmpty = true
        for part in parts {
            if (part != "") {
                allEmpty = false
                break
            }
        }
        if allEmpty {
            return nil
        }
        
        let date = parts[0]
        if (date != "") {
            self.currentDate = self.dateFromString(date)
        }
        
        let room = parts[1]
        if (room != "") {
            self.currentRoom = room
        }
        
        let times = parts[2].componentsSeparatedByString("-").map {$0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())}

        if (times[0] != "") {
            self.currentStartTime = self.timeFromString(times[0], date: self.currentDate!)
        }
        
        if (times.count >= 2) {
            if (times[1] != "") {
                self.currentEndTime = self.timeFromString(times[1], date: self.currentDate!)
            }
            else {
                self.currentEndTime = nil
            }
        }
        
        // Instructors are unique per row.
        let instructor = parts[3]
        
        let title = parts[4]
        if (title != "") {
            self.currentTitle = title
        }
        self.currentId += 1
        
        return Session(title: self.currentTitle!,
                       instructor: instructor,
                       room: self.currentRoom!,
                       info: "",
                       date: self.currentDate!,
                       timeStart: self.currentStartTime!,
                       timeEnd: self.currentEndTime
        )
    }
    
    func numberOfCols() -> Int {
        // First row has no newlines.
        let rows = self.rawData.componentsSeparatedByString("\n")
        return rows[0].componentsSeparatedByString(",").count
    }
    
    func dateFromString(dateString: String) -> NSDate {
        // Assumed to be split by slash
        let dateParts = dateString.componentsSeparatedByString("/")
        
        let components = NSDateComponents()
        components.month = Int(dateParts[0])!
        components.day = Int(dateParts[1])!
        components.year = 2016
        
        return self.calendar.dateFromComponents(components)!
    }
    
    /// Given a date and a time string construct an NSDate of that time.
    func timeFromString(timeString: String, date: NSDate) -> NSDate {
        //let yearComp = self.calendar.component(.Year, fromDate: date)
        //let monthComp = self.calendar.component(.Month, fromDate: date)
        //let dayComp = self.calendar.component(.Day, fromDate: date)
        let timeParts = timeString.componentsSeparatedByString(":")
        let hour = Int(timeParts[0])!
        let minute = Int(timeParts[1])!
        let timeDate = self.calendar.dateBySettingHour(hour, minute: minute, second: 0, ofDate: date, options: NSCalendarOptions.MatchStrictly)!
        return timeDate
    }
}