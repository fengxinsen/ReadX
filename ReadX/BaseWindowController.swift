//
//  BaseWindowController.swift
//  ReadX
//
//  Created by video on 2017/2/24.
//  Copyright © 2017年 Von. All rights reserved.
//

import Cocoa

class BaseWindowController: NSWindowController {
    
    open var index = 0
    
    override var windowNibName: String? {
        return "BaseWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
    }
}

extension BaseWindowController {
    
    //隐藏zoomButton
    func hiddenZoomButton() {
        self.window?.standardWindowButton(.zoomButton)?.isHidden = true
    }
    
    func hiddenTitleVisibility() {
        self.window?.titleVisibility = .hidden
    }
    
    func titleBackgroundColor(color: NSColor) {
        let titleView = self.window?.standardWindowButton(.closeButton)?.superview
        titleView?.backgroundColor = color
//        titleView?.wantsLayer = true
//        titleView?.layer?.backgroundColor = NSColor.brown.cgColor
    }
    
    func center() {
        self.window?.center()
    }
    
    func mAppDelegate() -> AppDelegate {
        return NSApplication.shared().delegate as! AppDelegate
    }
}
