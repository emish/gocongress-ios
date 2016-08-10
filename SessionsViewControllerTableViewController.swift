//
//  SessionsViewControllerTableViewController.swift
//  GoCongress
//
//  Created by emish on 7/31/16.
//  Copyright © 2016 emish. All rights reserved.
//

import UIKit

let SESSION_CELL_ID = "session_cell"

class SessionsViewControllerTableViewController: UITableViewController {

    var sectionsByTime = [NSDate: [Session]]()
    var sections = [NSDate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded as expected.")
        // Create our sections dict.
        
        for session in Data.sharedData.sessions {
            // Add the time start to our sections list.
            if (!self.sections.contains(session.timeStart)) {
                self.sections.append(session.timeStart)
            }
            
            // Store the list of sessions that start at that time.
            if var sessionList = self.sectionsByTime[session.timeStart] {
                sessionList.append(session)
                self.sectionsByTime[session.timeStart] = sessionList
            } else {
                self.sectionsByTime[session.timeStart] = [session]
            }
        }
        
        // FIXME: This is not sorting by date anymore... First store by date, then map to description.
        // Store in dictionary by date as well?
        self.sections.sortInPlace { (dateA, dateB) -> Bool in
            return dateA.compare(dateB) == .OrderedAscending
        }
        
        // TODO: order the lists of sessions by start date by end time
        dump(self.sections)
        dump(self.sectionsByTime)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // FIXME: This is the number of distinct start hours, every session in a section is one that starts at that hour.
        return self.sectionsByTime.keys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This is the number of sessions that share the same start hour.
        let dateForSection = self.sections[section]
        return self.sectionsByTime[dateForSection]!.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SESSION_CELL_ID, forIndexPath: indexPath)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        
        let session = self.sectionsByTime[self.sections[indexPath.section]]![indexPath.row]
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
        
        return dateFormatter.stringFromDate(self.sections[section])
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
