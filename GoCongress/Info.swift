//
//  Info.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/24/16.
//  Copyright © 2016 emish. All rights reserved.
//

import Foundation

enum Info {
    case infoList(String, [Info])
    case text(String, String)
    // There could be other cases for unique VC types that are displayed at the end of a nav InfoList
}

// Go Congress General Info
// FIXME: This goes into appdelegate or info root view and gets loaded from the directory.
let generalInfo = [
    Info.text("AGA Rules", "Summary"),
    Info.text("Special Thanks", "Special_Thanks"),
    Info.text("Professional Players", "Professional_Players"),
    Info.text("Setting Ing Clocks", "Setting_Ing_Clocks"),
    //Info.InfoList("Rules and Regulations", [
//        .Text("AGA Rules", "The rules will go here."),
//        ]),
]
