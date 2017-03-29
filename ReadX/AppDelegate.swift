//
//  AppDelegate.swift
//  ReadX
//
//  Created by video on 2017/3/22.
//  Copyright © 2017年 Von. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    internal var bookRule: Rule?
    
    fileprivate var appWindowControllers = [BaseWindowController]()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        
        bookRule = checkRule()
        
        let bookRoomWC = BookWindowController()
        bookRoomWC.contentViewController = BookRoomViewController()
        
        addWindowController(aWindowController: bookRoomWC).showWindow(nil)
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        //        return false
        return true
    }
    
    @IBAction func showAboutAction(_ sender: Any) {
        
        //        readXWC.showWindow(readXWC)
        //        readXWC.window?.makeKeyAndOrderFront(readXWC)
    }
}

extension AppDelegate {
    
    func AppWindowControllers() -> [BaseWindowController] {
        return appWindowControllers
    }
    
    func printWindowControllers() {
        print("AppWindowControllers = \(AppWindowControllers())")
    }
    
    func firstWindowController() -> BaseWindowController {
        return appWindowControllers.first!
    }
    
    func addWindowController(aWindowController: BaseWindowController) -> BaseWindowController{
        appWindowControllers.append(aWindowController)
        let index = appWindowControllers.index(of: aWindowController)
        print("addWC 位置在\(String(describing: index))")
        aWindowController.index = index!
        return aWindowController
    }
    
    func removeWindowController(index: Int) {
        if index < appWindowControllers.count {
            let baseWC = appWindowControllers[index]
            print("WC位置在\(baseWC.index)")
            print("移除WC 位置在\(index)")
            baseWC.window?.close()
            baseWC.contentViewController = nil
            appWindowControllers.remove(at: index)
        }
        printWindowControllers()
        if appWindowControllers.count == 1 {
            appWindowControllers.first?.showWindow(nil)
        }
    }
}

