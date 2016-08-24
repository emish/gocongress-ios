//
//  NSDate+GoCongressAdditions.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/23/16.
//  Copyright © 2016 emish. All rights reserved.
//

import Foundation

extension NSDate {

    var timeString: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle

        return dateFormatter.stringFromDate(self)
    }

    var simpleDateAndTimeString: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle

        return dateFormatter.stringFromDate(self)

    }
}