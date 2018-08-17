//
//  AppDelegate.swift
//  Open Terminal
//
//  Created by Quentin PÂRIS on 23/02/2016.
//  Copyright © 2016 QP. All rights reserved.
//

import Cocoa
import Darwin

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(aNotification: NSNotification) {
        let appleEventManager:NSAppleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURLEvent(event:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSLog("Installing Finder extension")
        SwiftySystem.execute(path: "/usr/bin/pluginkit", arguments: ["pluginkit", "-e", "use", "-i", "fr.qparis.openterminal.Open-Terminal-Finder-Extension"])
        SwiftySystem.execute(path: "/usr/bin/killall",arguments: ["Finder"])
        helpMe()
        exit(0)
    }
    
    @objc func handleGetURLEvent(event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let url = NSURL(string: event!.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!) {
            
            if let unwrappedPath = url.path {
                if(FileManager.default.fileExists(atPath: unwrappedPath)) {
                    do {
                        let rcContent = "cd \""+unwrappedPath+"\" \n" +
                            "[ -e \"$HOME/.profile\" ] && rcFile=\"~/.profile\" || rcFile=\"/etc/profile\"\n" +
                            "exec bash -c \"clear;printf '\\e[3J';bash --rcfile $rcFile\""
                        
                        try (rcContent).write(toFile: "/tmp/openTerminal", atomically: true, encoding: String.Encoding.utf8)
                        try FileManager.default.setAttributes([FileAttributeKey.posixPermissions: 0o777], ofItemAtPath: "/tmp/openTerminal")
                        SwiftySystem.execute(path: "/usr/bin/open", arguments: ["-b", "com.apple.terminal", "/tmp/openTerminal"])
                    } catch _ {}
                    
                } else {
                    helpMe(customMessage: "The specified directory does not exist")
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
        helpMe(customMessage: "This application adds a Open Terminal item in every Finder context menus.\n\n(c) Quentin PÂRIS 2016 - http://quentin.paris")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

