//
//  BaseViewController.swift
//  ReadX
//
//  Created by video on 2017/2/24.
//  Copyright © 2017年 Von. All rights reserved.
//

import Cocoa

class BaseViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension BaseViewController {
    func mAppDelegate() -> AppDelegate {
        return NSApplication.shared().delegate as! AppDelegate
    }
}
