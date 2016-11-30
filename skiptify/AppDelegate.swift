//
//  AppDelegate.swift
//  skiptify
//
//  Created by David Ungurean on 27/11/2016.
//  Copyright © 2016 David Ungurean. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: 100)
    let popover = NSPopover()
    
    var eventMonitor: Any?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
//                button.image =
            button.action = #selector(AppDelegate.togglePopover)
            button.title = "skiptify"
        }
        
        // init popover controller
        let sb = NSStoryboard(name: "Main", bundle: nil)
        popover.contentViewController = sb.instantiateController(withIdentifier: "MainViewController") as? NSViewController
        
        // we wanna hide the popup when user taps outside of it
        let mask: NSEventMask = [.leftMouseDown, .rightMouseDown]
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: { [unowned self] event in
            if self.popover.isShown {
                self.popover.performClose(event)
            }
        })
    }
    
    // MARK: - Action
    func togglePopover(sender: Any?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            guard let button = statusItem.button else {
                return
            }
            
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
        if let monitor = eventMonitor  {
            NSEvent.removeMonitor(monitor)
        }
        
    }


}

