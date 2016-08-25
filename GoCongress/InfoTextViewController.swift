//
//  InfoTextViewController.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/24/16.
//  Copyright © 2016 emish. All rights reserved.
//

import UIKit

class InfoTextViewController: UIViewController {

    var infoTitle: String!
    var infoContent: String!

    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoContentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.infoTitleLabel.text = self.infoTitle
        self.infoContentTextView.text = self.infoContent
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
