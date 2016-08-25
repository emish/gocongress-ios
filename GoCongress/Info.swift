//
//  Info.swift
//  GoCongress
//
//  Created by Mish Awadah on 8/24/16.
//  Copyright © 2016 emish. All rights reserved.
//

import Foundation

enum Info {
    case InfoList(String, [Info])
    case Text(String, String)
}

// Go Congress General Info
let generalInfo = [
    Info.Text("AGA Rules", "The rules will go here."),
    Info.InfoList("Rules and Regulations", [
        .Text("AGA Rules", "The rules will go here."),
        ]),
]