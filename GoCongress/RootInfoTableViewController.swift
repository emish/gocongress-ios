//
//  RootInfoTableViewController.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/24/16.
//  Copyright © 2016 emish. All rights reserved.
//

import UIKit

let ROOT_INFO_CELL_IDENTIFIER = "rootInfoCellIdentifier"

class RootInfoTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generalInfo.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ROOT_INFO_CELL_IDENTIFIER, forIndexPath: indexPath)

        let infoToPopulate: Info = generalInfo[indexPath.row]
        switch infoToPopulate {
        case .InfoList(let title, _):
            cell.textLabel?.text = title
        case .Text(let title, _):
            cell.textLabel?.text = title
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Present the new view controller
        let infoToDisplay: Info = generalInfo[indexPath.row]

        switch infoToDisplay {
        case .InfoList(let title, let infoList):
            // Make a new InfoTableViewController and push.
            let destinationViewController = self.navigationController!.storyboard!.instantiateViewControllerWithIdentifier("infoTableViewController") as! InfoTableViewController
            // Set the title of the nav bar.
            destinationViewController.title = title
            destinationViewController.infoObjects = infoList
            self.navigationController!.pushViewController(destinationViewController, animated: true)

        case .Text(let title, let content):
            // Make a new InfoViewController and push.
            let destinationViewController = self.navigationController!.storyboard!.instantiateViewControllerWithIdentifier("infoTextViewController") as! InfoTextViewController
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
