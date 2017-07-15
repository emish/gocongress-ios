//
//  NSDate+GoCongressAdditions.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/23/16.
//  Copyright © 2016 emish. All rights reserved.
//

import Foundation

extension Date {

    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: self)
    }

    var simpleDateAndTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: self)

    }
}
