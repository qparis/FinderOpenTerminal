//
//  FinderSync.swift
//  FinderExtension
//
//  Created by Quentin PÂRIS on 23/02/2016.
//  Copyright © 2018 Quentin PÂRIS. All rights reserved.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {
    
    var myFolderURL: URL = URL(fileURLWithPath: "/")
    
    override init() {
        super.init()
        
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath)
        
        // Set up the directory we are syncing.
        var directoryUrls = Set<URL>();
        directoryUrls.insert(self.myFolderURL);
        FIFinderSyncController.default().directoryURLs = directoryUrls;
    }
    
    override func menu(for menu: FIMenuKind) -> NSMenu? {
        // Produce a menu for the extension.
        let menu = NSMenu(title: NSLocalizedString("Open a terminal", comment:"Open a terminal"))
        menu.addItem(withTitle:  NSLocalizedString("Open a terminal", comment:"Open a terminal"), action: #selector(FinderSync.openTerminal(sender:)), keyEquivalent: "")
        return menu
    }
    
    @IBAction func openTerminal(sender: AnyObject?) {
        let target = FIFinderSyncController.default().targetedURL()
        
        guard let targetPath = target?.path.replacingOccurrences(of: " ", with: "%20"), let url = URL(string:"terminal://"+targetPath) else {
            return
        }
        NSWorkspace.shared.open(url)
    }
    
}

