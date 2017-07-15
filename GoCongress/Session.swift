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
    let date: Date
    let timeStart: Date
    /// The time a session ends. May not exist.
    let timeEnd: Date?

    static let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)

    init(title: String, instructor: String, room: String, info: String, date: Date, timeStart: Date, timeEnd: Date?) {
        self.title = title
        self.instructor = instructor
        self.room = room
        self.info = info
        self.date = date
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: "title") as? String,
            let instructor = aDecoder.decodeObject(forKey: "instructor") as? String,
            let room = aDecoder.decodeObject(forKey: "room") as? String,
            let info = aDecoder.decodeObject(forKey: "info") as? String,
            let date = aDecoder.decodeObject(forKey: "date") as? Date,
            let timeStart = aDecoder.decodeObject(forKey: "timeStart") as? Date,
            let timeEnd = aDecoder.decodeObject(forKey: "timeEnd") as? Date?
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

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.instructor, forKey: "instructor")
        aCoder.encode(self.room, forKey: "room")
        aCoder.encode(self.info, forKey: "info")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.timeStart, forKey: "timeStart")
        aCoder.encode(self.timeEnd, forKey: "timeEnd")
    }

    override func isEqual(_ object: Any?) -> Bool {
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
    let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    /// Parser internal state machine for progressing through the CSV.
    var currentDate: Date?
    var currentRoom: String?
    var currentStartTime: Date?
    var currentEndTime: Date?
    var currentTitle: String?
    var currentId: Int
    
    init(filename: String) {
        let bundle = Bundle.main
        self.fullPath = bundle.path(forResource: filename, ofType: "csv")!
        print("Filename loading: \(self.fullPath)")
        
        self.rawData = try! String(contentsOfFile: self.fullPath)
        print("Contents: \n --- \n\(self.rawData)\n---\n")

        self.currentId = 0
    }
    
    /// Parse the input CSV file that was configured in the initializer and return the list of Sessions generated.
    mutating func parse() -> [Session] {
        var sessions = [Session]()
        let rows = self.rawData.components(separatedBy: "\r\n")
        for (i, row) in rows.enumerated() {
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
    mutating func parseRow(_ row: String) -> Session? {
        let parts = row.components(separatedBy: ",")
        
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
        
        let times = parts[2].components(separatedBy: "-").map {$0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)}

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
        let rows = self.rawData.components(separatedBy: "\n")
        return rows[0].components(separatedBy: ",").count
    }
    
    func dateFromString(_ dateString: String) -> Date {
        // Assumed to be split by slash
        let dateParts = dateString.components(separatedBy: "/")
        
        var components = DateComponents()
        components.month = Int(dateParts[0])!
        components.day = Int(dateParts[1])!
        components.year = 2016
        
        return self.calendar.date(from: components)!
    }
    
    /// Given a date and a time string construct an NSDate of that time.
    func timeFromString(_ timeString: String, date: Date) -> Date {
        //let yearComp = self.calendar.component(.Year, fromDate: date)
        //let monthComp = self.calendar.component(.Month, fromDate: date)
        //let dayComp = self.calendar.component(.Day, fromDate: date)
        let timeParts = timeString.components(separatedBy: ":")
        let hour = Int(timeParts[0])!
        let minute = Int(timeParts[1])!
        let timeDate = (self.calendar as NSCalendar).date(bySettingHour: hour, minute: minute, second: 0, of: date, options: NSCalendar.Options.matchStrictly)!
        return timeDate
    }
}
