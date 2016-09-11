//
//  MapsViewController.swift
//  GoCongress
//
//  Created by emish on 7/31/16.
//  Copyright © 2016 emish. All rights reserved.
//

import UIKit

class MapsPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    /// List of map names by file. This is the same as the name of the map itself.
    var mapNames = [String]()
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // FIXME: Right now we just use static map names, but we'd like to just scan the directory where maps are stored and display those. Seems that is harder than it looks. We might want to supply the image names in a file.
        self.mapNames = [
            "First Floor",
            "Second Floor",
            "Third Floor",
            "Basement"
        ]
        self.dataSource = self
        self.setViewControllers([self.viewControllerAtIndex(0)], direction: .Forward, animated: false, completion: nil)
        self.navigationItem.title = self.mapNames[0]
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! MapImageViewController).pageIndex
        if index == 0 {
            return nil
        } else {
            let nextVC = self.viewControllerAtIndex(index-1)
            //self.navigationItem.title = nextVC.mapName
            return nextVC
        }
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! MapImageViewController).pageIndex
        if index == self.mapNames.count - 1 {
            return nil
        } else {
            let nextVC = self.viewControllerAtIndex(index+1)
            //self.navigationItem.title = nextVC.mapName
            return nextVC
        }
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.mapNames.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        // how to find out the current view controller being displayed??
        return 0
    }

    // MARK: - Internal Helpers

    private func viewControllerAtIndex(index: Int) -> MapImageViewController {
        let mapImageVC: MapImageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapImageViewController") as! MapImageViewController
        mapImageVC.mapName = self.mapNames[index]
        mapImageVC.pageIndex = index

        return mapImageVC
    }
}
