//
//  AppDelegate.swift
//  Open Terminal
//
//  Created by Quentin PÂRIS on 23/02/2016.
//  Copyright © 2016 QP. All rights reserved.
//

import Cocoa
import Darwin

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(aNotification: NSNotification) {
        let appleEventManager:NSAppleEventManager = NSAppleEventManager.sharedAppleEventManager()
        appleEventManager.setEventHandler(self, andSelector: "handleGetURLEvent:replyEvent:", forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        system("pluginkit -e use -i fr.qparis.openterminal.Open-Terminal-Finder-Extension ; killall Finder")
        helpMe()
        exit(0)
    }
    
    func handleGetURLEvent(event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let url = NSURL(string: event!.paramDescriptorForKeyword(AEKeyword(keyDirectObject))!.stringValue!) {
            if let unwrappedPath = url.path {
                if(NSFileManager.defaultManager().fileExistsAtPath(unwrappedPath)) {

                    do {
                        let rcContent = "cd \""+unwrappedPath+"\" \n" +
                            "[ -e \"$HOME/.profile\" ] && rcFile=\"~/.profile\" || rcFile=\"/etc/profile\"\n" +
                            "exec bash -c \"clear;printf '\\e[3J';bash --rcfile $rcFile\""
                        
                        try (rcContent).writeToFile("/tmp/openTerminal", atomically: true, encoding: NSUTF8StringEncoding)
                        try NSFileManager.defaultManager().setAttributes([NSFilePosixPermissions: 0o777], ofItemAtPath: "/tmp/openTerminal")
                            system("open -b com.apple.terminal /tmp/openTerminal")
                    } catch _ {}
                    
                } else {
                    helpMe("The specified directory does not exist")
                }
                
            }
        }
        
        exit(0)
    }
    
    private func helpMe(customMessage: String) {
        let alert = NSAlert ()
        alert.messageText = "Information"
        alert.informativeText = customMessage
        alert.runModal()
    }
    
    private func helpMe() {
        helpMe("This application adds a Open Terminal item in every Finder context menus.\n\n(c) Quentin PÂRIS 2016 - http://quentin.paris")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

