//
//  GoCongressTests.swift
//  GoCongressTests
//
//  Created by emish on 8/4/16.
//  Copyright © 2016 emish. All rights reserved.
//

import XCTest

let TEST_FILENAME = "congress_schedule"

class GoCongressTests: XCTestCase {

    var parser = SessionParser(filename: TEST_FILENAME)

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // Restart the parser before each test.
        parser = SessionParser(filename: TEST_FILENAME)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDateFromString() {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = NSDateComponents()
        components.month = 1
        components.day = 1
        components.year = 2016

        let testDate = calendar?.dateFromComponents(components)
        let testStringDate = parser.dateFromString("01/01/2016")

        XCTAssertEqual(testDate, testStringDate)
    }

    func testTimeFromString() {
        let components = NSDateComponents()
        components.month = 8
        components.day = 1
        components.year = 2016

        let dayOnly = self.parser.calendar.dateFromComponents(components)!

        components.hour = 15
        components.minute = 0

        let realTime = self.parser.calendar.dateFromComponents(components)
        let testString = "15:00"
        let testTime = parser.timeFromString(testString, date: dayOnly)
        XCTAssertEqual(testTime, realTime)
    }

    func testParseRowRegular() {
        let row = "7/31,Ballroom,09:00 - 12:00,Matthew Hershberger,US Open (round 1)"

        let currDate = self.parser.dateFromString("7/31")
        let correctSession = Session(title: "US Open (round 1)",
                                     instructor: "Matthew Hershberger",
                                     room: "Ballroom",
                                     info: "",
                                     date: currDate,
                                     timeStart: self.parser.timeFromString("09:00", date: currDate),
                                     timeEnd: self.parser.timeFromString("12:00", date: currDate))
        let testSession = self.parser.parseRow(row)!

        XCTAssertTrue(correctSession == testSession)
    }

    func testParseRowMissingEndTime() {
        let row = "7/30,Lobby,10:00 - ,Neil Ritter,Registration"

        let currDate = self.parser.dateFromString("7/30")
        let correctSession = Session(title: "Registration",
                                     instructor: "Neil Ritter",
                                     room: "Lobby",
                                     info: "",
                                     date: currDate,
                                     timeStart: self.parser.timeFromString("10:00", date: currDate),
                                     timeEnd: nil)
        let testSession = self.parser.parseRow(row)!

        XCTAssertTrue(correctSession == testSession)
    }

    func testParseRowSequenceMissingValues() {
        let row1 = "7/31,Ballroom,09:00 - 12:00,Matthew Hershberger,US Open (round 1)"
        let row2 = ",Terrace Lounge,09:00 - 12:00,Matthew Hershberger,US Open Master (round 1)"
        let row3 = ",,15:00 - 17:00,Paul Barchilon,Redmond Cup Final (round 1)"
        let row4 = ",Ballroom B,13:00 - 14:50,Liao Guiyong,Simul Games"
        let row5 = ",,,Zhou Jie,"
        let row6 = ",,15:00 - 16:50,Ailin Hsiao,"
        let row7 = ",,,On Sojin,"

        let currDate = self.parser.dateFromString("7/31")
        let correctSession1 = Session(title: "US Open (round 1)",
                                      instructor: "Matthew Hershberger",
                                      room: "Ballroom",
                                      info: "",
                                      date: currDate,
                                     timeStart: self.parser.timeFromString("09:00", date: currDate),
                                     timeEnd: self.parser.timeFromString("12:00", date: currDate))

        let correctSession2 = Session(title: "US Open Master (round 1)",
                                      instructor: "Matthew Hershberger",
                                      room: "Terrace Lounge",
                                      info: "",
                                      date: currDate,
                                      timeStart: self.parser.timeFromString("09:00", date: currDate),
                                      timeEnd: self.parser.timeFromString("12:00", date: currDate))

        let correctSession3 = Session(title: "Redmond Cup Final (round 1)",
                                      instructor: "Paul Barchilon",
                                      room: "Terrace Lounge",
                                      info: "",
                                      date: currDate,
                                      timeStart: self.parser.timeFromString("15:00", date: currDate),
                                      timeEnd: self.parser.timeFromString("17:00", date: currDate))

        let correctSession4 = Session(title: "Simul Games",
                                      instructor: "Liao Guiyong",
                                      room: "Ballroom B",
                                      info: "",
                                      date: currDate,
                                      timeStart: self.parser.timeFromString("13:00", date: currDate),
                                      timeEnd: self.parser.timeFromString("14:50", date: currDate))

        let correctSession5 = Session(title: "Simul Games",
                                      instructor: "Zhou Jie",
                                      room: "Ballroom B",
                                      info: "",
                                      date: currDate,
                                      timeStart: self.parser.timeFromString("13:00", date: currDate),
                                      timeEnd: self.parser.timeFromString("14:50", date: currDate))

        let correctSession6 = Session(title: "Simul Games",
                                      instructor: "Ailin Hsiao",
                                      room: "Ballroom B",
                                      info: "",
                                      date: currDate,
                                      timeStart: self.parser.timeFromString("15:00", date: currDate),
                                      timeEnd: self.parser.timeFromString("16:50", date: currDate))

        let correctSession7 = Session(title: "Simul Games",
                                      instructor: "On Sojin",
                                      room: "Ballroom B",
                                      info: "",
                                      date: currDate,
                                      timeStart: self.parser.timeFromString("15:00", date: currDate),
                                      timeEnd: self.parser.timeFromString("16:50", date: currDate))

        XCTAssertTrue(self.parser.parseRow(row1)! == correctSession1)
        XCTAssertTrue(self.parser.parseRow(row2)! == correctSession2)
        XCTAssertTrue(self.parser.parseRow(row3)! == correctSession3)
        XCTAssertTrue(self.parser.parseRow(row4)! == correctSession4)
        XCTAssertTrue(self.parser.parseRow(row5)! == correctSession5)
        XCTAssertTrue(self.parser.parseRow(row6)! == correctSession6)
        XCTAssertTrue(self.parser.parseRow(row7)! == correctSession7)
    }

    func testParseDoesntCrash() {
        self.parser.parse()
    }

}
