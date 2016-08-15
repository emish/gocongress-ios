//
//  SessionsViewControllerTableViewController.swift
//  GoCongress
//
//  Created by emish on 7/31/16.
//  Copyright © 2016 emish. All rights reserved.
//

import UIKit

let SESSION_CELL_ID = "session_cell"
let SESSION_DETAIL_VIEW_SEGUE = "sessionDetailViewSegue"

class SessionsViewControllerTableViewController: UITableViewController {

    var allSectionsByTime = [NSDate: [Session]]()
    var allSections = [NSDate]()

    var favoriteSectionsByTime = [NSDate: [Session]]()
    var favoriteSections = [NSDate]()

    var showingSectionsByTime = [NSDate: [Session]]()
    var showingSections = [NSDate]()

    @IBOutlet weak var sessionFilter: UISegmentedControl!
    var showingFavorites: Bool = false

    /// Return a sorted array of sections by date and dictionary of sections indexed by date.
    func populateSectionsFromDataSource(dataSource: [Session]) -> ([NSDate], [NSDate: [Session]]) {
        var tmpSections = [NSDate]()
        var tmpSectionsByTime = [NSDate: [Session]]()

        for session in dataSource {
            // Add the time start to our sections list.
            if (!tmpSections.contains(session.timeStart)) {
                tmpSections.append(session.timeStart)
            }

            // Store the list of sessions that start at that time.
            if var sessionList = tmpSectionsByTime[session.timeStart] {
                sessionList.append(session)
                tmpSectionsByTime[session.timeStart] = sessionList
            } else {
                tmpSectionsByTime[session.timeStart] = [session]
            }
        }

        // FIXME: This is not sorting by date anymore... First store by date, then map to description.
        // Store in dictionary by date as well?
        tmpSections.sortInPlace { (dateA, dateB) -> Bool in
            return dateA.compare(dateB) == .OrderedAscending
        }

        return (tmpSections, tmpSectionsByTime)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded as expected.")

        // TODO: Load favorites too (from NSUserDefaults)
        (self.allSections, self.allSectionsByTime) = self.populateSectionsFromDataSource(Data.sharedData.sessions)

        self.showingSections = self.allSections
        self.showingSectionsByTime = self.allSectionsByTime
    }

    override func viewWillAppear(animated: Bool) {
        if self.showingFavorites {
            self.refilterFavorites()
            (self.showingSections, self.showingSectionsByTime) = (self.favoriteSections, self.favoriteSectionsByTime)
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // FIXME: This is the number of distinct start hours, every session in a section is one that starts at that hour.
        return self.showingSectionsByTime.keys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This is the number of sessions that share the same start hour.
        let dateForSection = self.showingSections[section]
        return self.showingSectionsByTime[dateForSection]!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SESSION_CELL_ID, forIndexPath: indexPath)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        
        let session = self.showingSectionsByTime[self.showingSections[indexPath.section]]![indexPath.row]
        cell.textLabel!.text = "\(session.title) - \(session.instructor)"
        let timeEndString: String
        if let timeEnd = session.timeEnd {
            timeEndString = " - \(dateFormatter.stringFromDate(timeEnd))"
        } else {
            timeEndString = ""
        }
        cell.detailTextLabel!.text = "\(dateFormatter.stringFromDate(session.timeStart))\(timeEndString) -- \(session.room)"
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(self.showingSections[section])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == SESSION_DETAIL_VIEW_SEGUE) {
            let detailViewController = segue.destinationViewController as! SessionDetailViewController
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
            let session = self.showingSectionsByTime[self.showingSections[indexPath!.section]]![indexPath!.row]
            detailViewController.session = session
        }
    }

    // MARK: - Filtering Favorites

    @IBAction func filterValueChanged(sender: UISegmentedControl) {
        // Showing favorites
        if sender.selectedSegmentIndex == 1 {
            self.refilterFavorites()
            self.showingFavorites = true
            self.showingSections = self.favoriteSections
            self.showingSectionsByTime = self.favoriteSectionsByTime
        } else {
            // Showing all
            self.showingFavorites = false
            self.showingSections = self.allSections
            self.showingSectionsByTime = self.allSectionsByTime
        }

        self.tableView.reloadData()
    }

    func refilterFavorites() {
        (self.favoriteSections, self.favoriteSectionsByTime) = self.populateSectionsFromDataSource(Data.sharedData.sessions.filter({ (s: Session) -> Bool in
            Data.sharedData.user.favorites.contains(s)
        }))
    }

}
