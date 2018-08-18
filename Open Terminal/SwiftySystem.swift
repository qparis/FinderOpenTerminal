//
//  SwiftySystem.swift
//  OpenTerminal
//
//  Created by Benny Lach on 28.10.16.
//  Copyright © 2016 QP. All rights reserved.
//

import Foundation

class SwiftySystem {
    static func execute(path: String?, arguments: [String]?) {
        let pipe = Pipe()
        
        let task = Process()
        task.launchPath = path
        task.arguments = arguments
        task.standardOutput = pipe
        task.launch()
        
        task.waitUntilExit()
    }
}
