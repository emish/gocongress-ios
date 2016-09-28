//
//  SessionDetailViewController.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/10/16.
//  Copyright © 2016 emish. All rights reserved.
//

import UIKit

class SessionDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructorLabel: UILabel!

    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var saveRemoveButton: UIBarButtonItem!
    @IBOutlet weak var contentView: UIView!

    var session: Session! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Cannot make one of these unless you have a session. If this is not true, the universe collapses.
        guard let session = self.session else {
            fatalError("Got no session when loading Detail View for session. Segue broke?")
        }
        self.titleLabel.text = session.title
        self.instructorLabel.text = session.instructor
        // TODO: Some NSDateFormatter magic
        self.dateTimeLabel.text = "\(session.timeStart) - \(session.timeEnd)"
        self.roomLabel.text = session.room

        // Place and size the description View to fit
        // FIXME Later, use description
        //self.descriptionTextView.text = session.description

        self.descriptionTextView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."

        let user = Data.sharedData.user
        self.saveRemoveButton.title = (user.favorites.contains(session)) ? "Remove" : "Save"
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Set the height constraint to the size of the fitted view after text is inserted.
        // https://medium.com/@pj_/ios-tips-dynamic-uitextview-102e73853fbc#.jzbn2fz7d
        self.descriptionTextView.sizeToFit()
        //let size = self.descriptionTextView.contentSize
        //self.descriptionHeightConstraint.constant = size.height
        //self.descriptionTextView.scrollEnabled = false
        self.contentView.sizeToFit()
    }

    @IBAction func saveRemoveButtonTapped(sender: UIBarButtonItem) {
        var user = Data.sharedData.user

        if user.favorites.contains(self.session) {
            user.favorites.removeAtIndex(user.favorites.indexOf(session)!)
            self.saveRemoveButton.title = "Save"
        } else {
            user.favorites.append(session)
            self.saveRemoveButton.title = "Remove"
        }

        Data.sharedData.user = user
        Data.sharedData.syncUserData()
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
