//
//  BookWindowController.swift
//  ReadX
//
//  Created by video on 2017/3/17.
//  Copyright © 2017年 Von. All rights reserved.
//

import Cocoa

class BookWindowController: BaseWindowController {

    override var windowNibName: String? {
        return "BookWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.styleMask = [.unifiedTitleAndToolbar, .closable, .miniaturizable, .titled]
        
        hiddenZoomButton()
        
        hiddenTitleVisibility()
        
        titleBackgroundColor(color: NSColor.brown)
        
        center()
        
        setUpToolbar()
    }
    
}

extension BookWindowController: NSToolbarDelegate {
    
    func setUpToolbar(){
        let toolbar = NSToolbar(identifier: "AppToolbar")
        toolbar.allowsUserCustomization = false
        toolbar.autosavesConfiguration = false
        toolbar.displayMode = .iconOnly
        toolbar.delegate = self
        self.window?.toolbar = toolbar
    }
    
    //实际显示的item 标识
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        return ["refresh_chapters", NSToolbarFlexibleSpaceItemIdentifier, "add"]
    }
    
    //所有的item 标识,在编辑模式下会显示出所有的item
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        return ["refresh_chapters", NSToolbarFlexibleSpaceItemIdentifier, "add"]
    }
    
    //根据item 标识 返回每个具体的NSToolbarItem对象实例
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        if itemIdentifier == "refresh_chapters" {
            toolbarItem.tag = 1
            let size = NSSize(width: 66, height: 22)
            let refresh = NSButton.init(frame: NSRect.init(x: 0, y: 0, width: size.width, height: size.height))
            refresh.bezelStyle = .roundRect
            refresh.title = "刷新目录"
            toolbarItem.view = refresh
            toolbarItem.minSize = size
            toolbarItem.maxSize = size
            refresh.target = self
            refresh.action = #selector(refreshBookRoomAction(_:))
        }
        if itemIdentifier == NSToolbarFlexibleSpaceItemIdentifier {
            toolbarItem.tag = 2
        }
        if itemIdentifier == "add" {
            toolbarItem.tag = 3
            let size = NSSize(width: 33, height: 22)
            let add = NSButton.init(frame: NSRect.init(x: 0, y: 0, width: size.width, height: size.height))
            add.bezelStyle = .roundRect
            add.title = "+"
            toolbarItem.view = add
            toolbarItem.minSize = size
            toolbarItem.maxSize = size
            add.target = self
            add.action = #selector(addBookAction(_:))
        }
        
        return toolbarItem
    }
    
    func refreshBookRoomAction(_ sender: NSButton) {
        NotificationCenter.default.post(name: Book_RoomChaptersRefresh_Notification, object: nil)
    }
    
    func addBookAction(_ sender: NSButton) {
        let bookAdd = BookAddViewController()
        let pop = NSPopover.init()
        pop.behavior = .semitransient
        pop.delegate = self
        bookAdd.popover = pop
        pop.contentViewController = bookAdd
        pop.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
    }
    
    func toolbarItemClicked(_ sender:NSToolbarItem) {
        let tag = sender.tag
        switch tag {
        case 0:  print("0")
        case 1:  print("1")
        default:
            print("1000")
        }
    }
}

extension BookWindowController: NSPopoverDelegate {
    func popoverDidClose(_ notification: Notification) {
        let pop = notification.object as! NSPopover
        let add = pop.contentViewController as! BookAddViewController
        add.popover = nil
    }
}
