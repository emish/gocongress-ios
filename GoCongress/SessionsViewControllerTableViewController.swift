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

    var allSectionsByTime = [Date: [Session]]()
    var allSections = [Date]()

    var favoriteSectionsByTime = [Date: [Session]]()
    var favoriteSections = [Date]()

    var showingSectionsByTime = [Date: [Session]]()
    var showingSections = [Date]()

    @IBOutlet weak var sessionFilter: UISegmentedControl!
    var showingFavorites: Bool = false

    /// Return a sorted array of sections by date and dictionary of sections indexed by date.
    func populateSectionsFromDataSource(_ dataSource: [Session]) -> ([Date], [Date: [Session]]) {
        var tmpSections = [Date]()
        var tmpSectionsByTime = [Date: [Session]]()

        for session in dataSource {
            // Add the time start to our sections list.
            if (!tmpSections.contains(session.timeStart as Date)) {
                tmpSections.append(session.timeStart as Date)
            }

            // Store the list of sessions that start at that time.
            if var sessionList = tmpSectionsByTime[session.timeStart as Date] {
                sessionList.append(session)
                tmpSectionsByTime[session.timeStart as Date] = sessionList
            } else {
                tmpSectionsByTime[session.timeStart as Date] = [session]
            }
        }

        // FIXME: This is not sorting by date anymore... First store by date, then map to description.
        // Store in dictionary by date as well?
        tmpSections.sort { (dateA, dateB) -> Bool in
            return dateA.compare(dateB) == .orderedAscending
        }

        return (tmpSections, tmpSectionsByTime)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded as expected.")

        (self.allSections, self.allSectionsByTime) = self.populateSectionsFromDataSource(Data.sharedData.sessions)
        (self.favoriteSections, self.favoriteSectionsByTime) = self.populateSectionsFromDataSource(Data.sharedData.user.favorites)

        self.showingSections = self.allSections
        self.showingSectionsByTime = self.allSectionsByTime
    }

    override func viewWillAppear(_ animated: Bool) {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // FIXME: This is the number of distinct start hours, every session in a section is one that starts at that hour.
        return self.showingSectionsByTime.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This is the number of sessions that share the same start hour.
        let dateForSection = self.showingSections[section]
        return self.showingSectionsByTime[dateForSection]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SESSION_CELL_ID, for: indexPath)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        let session = self.showingSectionsByTime[self.showingSections[indexPath.section]]![indexPath.row]
        cell.textLabel!.text = "\(session.title) - \(session.instructor)"
        let timeEndString: String
        if let timeEnd = session.timeEnd {
            timeEndString = " - \(dateFormatter.string(from: timeEnd as Date))"
        } else {
            timeEndString = ""
        }
        cell.detailTextLabel!.text = "\(dateFormatter.string(from: session.timeStart as Date))\(timeEndString) -- \(session.room)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: self.showingSections[section])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == SESSION_DETAIL_VIEW_SEGUE) {
            let detailViewController = segue.destination as! SessionDetailViewController
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let session = self.showingSectionsByTime[self.showingSections[indexPath!.section]]![indexPath!.row]
            detailViewController.session = session
        }
    }

    // MARK: - Filtering Favorites

    @IBAction func filterValueChanged(_ sender: UISegmentedControl) {
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
        (self.favoriteSections, self.favoriteSectionsByTime) = self.populateSectionsFromDataSource(Data.sharedData.sessions.filter
            { (s: Session) -> Bool in
                Data.sharedData.user.favorites.contains(s)
            })
    }

}
