//
//  SwiftySystem.swift
//  OpenTerminal
//
//  Created by Benny Lach on 28.10.16.
//  Copyright © 2016 QP. All rights reserved.
//

import Foundation

struct SwiftySystem {
    static func execute(path: String?, arguments: [String]?) {
        let pipe = NSPipe()
        
        let task = NSTask()
        task.launchPath = path
        task.arguments = arguments
        task.standardOutput = pipe
        task.launch()
        
        task.waitUntilExit()
    }
}
