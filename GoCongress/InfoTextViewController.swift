//
//  InfoTextViewController.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/24/16.
//  Copyright © 2016 emish. All rights reserved.
//

import UIKit
import MMMarkdown

/// Given a Title and a path, render the text in the markdown file at path in a VC.
class InfoTextViewController: UIViewController {

    var infoTitle: String!
    var infoContent: String!

    //@IBOutlet weak var infoTitleLabel: UILabel!
    //@IBOutlet weak var infoContentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.infoTitleLabel.text = self.infoTitle
        // FIXME the nav bar title

        // FIXME this is the path
        //self.infoContentTextView.text = self.infoContent
        let file: NSURL = NSBundle.mainBundle().URLForResource(infoContent, withExtension: "md", subdirectory: "Info")!
        var mdString = try! MMMarkdown.HTMLStringWithMarkdown(String(contentsOfURL: file))

        // Rewrite image paths.
        //mdString = mdString.stringByReplacingOccurrencesOfString("<img src=\"", withString: "<img src=\"" + NSBundle.mainBundle().bundlePath + "/Info/")

        let webView = UIWebView(frame: self.view.frame)
        webView.loadHTMLString(mdString, baseURL: NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent("Info"))
        self.view.addSubview(webView)
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
