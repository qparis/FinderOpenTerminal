//
//  FinderSync.swift
//  FinderExtension
//
//  Created by Quentin PÂRIS on 23/02/2016.
//  Copyright © 2016 QP. All rights reserved.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {
    
    var myFolderURL: NSURL = NSURL(fileURLWithPath: "/")
    
    override init() {
        super.init()
        
        NSLog("FinderSync() launched from %@", NSBundle.mainBundle().bundlePath)
        
        // Set up the directory we are syncing.
        FIFinderSyncController.defaultController().directoryURLs = [self.myFolderURL]
    }
    
    
    
    override func menuForMenuKind(menuKind: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        let menu = NSMenu(title: "Open Terminal")
        menu.addItemWithTitle("Open Terminal", action: "openTerminal:", keyEquivalent: "")
        return menu
    }
    
    @IBAction func openTerminal(sender: AnyObject?) {
        let target = FIFinderSyncController.defaultController().targetedURL()
        
        if let targetPath = target?.path {
            system("open \"terminal://"+targetPath+"\"")
        }
    }
    
}

