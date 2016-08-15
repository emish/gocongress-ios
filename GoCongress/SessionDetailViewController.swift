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
    @IBOutlet weak var descriptionTextViewHeight: NSLayoutConstraint!

    @IBOutlet weak var saveRemoveButton: UIBarButtonItem!

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
        self.descriptionTextView.text = session.description
        // TODO: Size the height constraint; http://stackoverflow.com/questions/50467/how-do-i-size-a-uitextview-to-its-content
        //let heightThatFitsView = UITextView.sizethat

        let user = Data.sharedData.user
        self.saveRemoveButton.title = (user.favorites.contains(session)) ? "Remove" : "Save"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
