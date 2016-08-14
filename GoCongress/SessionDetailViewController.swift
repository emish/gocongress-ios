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

    var session: Session? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let session = self.session {
            self.titleLabel.text = session.title
        } else {
            self.titleLabel.text = "ERROR"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
