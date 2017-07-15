//
//  InfoTableViewController.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/24/16.
//  Copyright © 2016 emish. All rights reserved.
//

import UIKit

let INFO_TABLE_CELL_IDENTIFIER = "infoTableCellIdentifier"

class InfoTableViewController: UITableViewController {

    /// The information displayed by this Info Table. By default (the root view controller)
    /// Displays the global general info.
    var infoObjects: [Info]! = generalInfo

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Only one section in sub info pages, the root info page can have multiple sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: INFO_TABLE_CELL_IDENTIFIER, for: indexPath)

        let infoToPopulate: Info = self.infoObjects[indexPath.row]
        switch infoToPopulate {
        case .infoList(let title, _):
            cell.textLabel?.text = title
        case .text(let title, _):
            cell.textLabel?.text = title
        }

        return cell
    }

    // Same as RootInfo here.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present the new view controller
        let infoToDisplay: Info = self.infoObjects[indexPath.row]

        switch infoToDisplay {
        case .infoList(let title, let infoList):
            // Make a new InfoTableViewController and push.
            let destinationViewController = self.navigationController!.storyboard!.instantiateViewController(withIdentifier: "infoTableViewController") as! InfoTableViewController
            // Set the title of the nav bar.
            destinationViewController.title = title
            destinationViewController.infoObjects = infoList
            self.navigationController!.pushViewController(destinationViewController, animated: true)

        case .text(let title, let content):
            // Make a new InfoViewController and push.
            let destinationViewController = self.navigationController!.storyboard!.instantiateViewController(withIdentifier: "infoTextViewController") as! InfoTextViewController
            // Set the title of the nav bar.
            destinationViewController.title = title
            destinationViewController.infoTitle = title
            destinationViewController.infoContent = content
            self.navigationController!.pushViewController(destinationViewController, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
