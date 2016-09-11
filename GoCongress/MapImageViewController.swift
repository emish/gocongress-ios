//
//  MapImageViewController.swift
//  GoCongress
//
//  Created by Mish Awadah on 9/11/16.
//  Copyright © 2016 emish. All rights reserved.
//

import UIKit

class MapImageViewController: UIViewController {

    @IBOutlet weak var mapImage: UIImageView!

    /// The name of the map. Used to display the nav bar title and access the correct image.
    var mapName: String!

    /// The default page index. Or would we rather crash if we are using it before its set?
    var pageIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(self.mapName != nil && self.pageIndex != nil,
               "Can't set up a MapImageViewController without these properties set first.")

        // Set up the nav bar title and image view.
        self.mapImage.image = UIImage(named: self.mapName)
    }

    override func viewDidAppear(animated: Bool) {
        self.parentViewController?.navigationItem.title = self.mapName
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
