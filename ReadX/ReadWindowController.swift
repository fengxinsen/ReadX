//
//  ReadWindowController.swift
//  ReadX
//
//  Created by video on 2017/2/23.
//  Copyright © 2017年 Von. All rights reserved.
//

import Cocoa

class ReadWindowController: BaseWindowController {
    
    deinit {
        print("rwc xxx")
        titleView.removeObserver(self, forKeyPath: "self.window.title")
    }
    
    override var windowNibName: String? {
        return "ReadWindowController"
    }
    
    lazy var titleView: NSTextField = {
        let tf = NSTextField.init(string: self.window?.title)
        tf.isEditable = false
        tf.isBezeled = false
        tf.isSelectable = false
        tf.alignment = .center
        return tf
    }()
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.styleMask = [.unifiedTitleAndToolbar, .closable, .miniaturizable, .resizable, .titled]
        
        self.window?.title = "ReadWC"
        self.window?.setFrame(CGRect.init(x: 0, y: 0, width: 480, height: 640), display: true)
        closeWindow()
        
        hiddenTitleVisibility()
        
        titleBackgroundColor(color: NSColor.brown)
        
        center()
        
        setUpToolbar()
        
        titleView.addObserver(self, forKeyPath: "self.window.title", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "self.window.title" {
            titleView.stringValue = change?.values.first as! String
        }
    }
    
    func closeWindow() {
        let closeButton = self.window?.standardWindowButton(.closeButton)
        closeButton?.target = self
        closeButton?.action = #selector(closeAction(_:))
    }
    
    func closeAction(_ sender: Any) {
        print("点击close \(String(describing: self.window?.title))")
        mAppDelegate().removeWindowController(index: index)
    }
}

extension ReadWindowController: NSToolbarDelegate {
    
    func ItemIdentifiers() -> [String] {
        return ["showRoom", "chapters", NSToolbarFlexibleSpaceItemIdentifier, "title",NSToolbarFlexibleSpaceItemIdentifier, "setting"]
    }
    
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
        return ItemIdentifiers()
    }
    
    //所有的item 标识,在编辑模式下会显示出所有的item
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        return ItemIdentifiers()
    }
    
    //根据item 标识 返回每个具体的NSToolbarItem对象实例
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        let size = NSSize(width: 44, height: 22)
        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        if itemIdentifier == ItemIdentifiers()[0] {
            toolbarItem.tag = 0
            let room = NSButton.init(frame: NSRect.init(x: 0, y: 0, width: size.width, height: size.height))
            room.tag = toolbarItem.tag
            room.bezelStyle = .roundRect
//            add.setButtonType(.pushOnPushOff)
            room.title = "书库"
            toolbarItem.view = room
            toolbarItem.minSize = size
            toolbarItem.maxSize = size
            room.target = self
            room.action = #selector(toolbarItemButtonAction(_:))
        }
        if itemIdentifier == ItemIdentifiers()[1] {
            toolbarItem.tag = 1
            let chapters = NSButton.init(frame: NSRect.init(x: 0, y: 0, width: size.width, height: size.height))
            chapters.tag = toolbarItem.tag
            chapters.bezelStyle = .roundRect
//            add.setButtonType(.pushOnPushOff)
            chapters.title = "目录"
            toolbarItem.view = chapters
            toolbarItem.minSize = size
            toolbarItem.maxSize = size
            chapters.target = self
            chapters.action = #selector(toolbarItemButtonAction(_:))
        }
        if itemIdentifier == ItemIdentifiers()[2] || itemIdentifier == ItemIdentifiers()[4] {
            toolbarItem.tag = 2
        }
        if itemIdentifier == ItemIdentifiers()[3] {
            titleView.backgroundColor = NSColor.clear
            toolbarItem.view = titleView
            toolbarItem.minSize = NSSize.init(width: 220, height: 22)
            toolbarItem.maxSize = NSSize.init(width: 1200, height: 22)
        }
        if itemIdentifier == ItemIdentifiers()[5] {
            toolbarItem.tag = 5
            let setting = NSButton.init(frame: NSRect.init(x: 0, y: 0, width: size.width, height: size.height))
            setting.tag = toolbarItem.tag
            setting.bezelStyle = .roundRect
//            add.setButtonType(.pushOnPushOff)
            setting.title = "设置"
            toolbarItem.view = setting
            toolbarItem.minSize = size
            toolbarItem.maxSize = size
            setting.target = self
            setting.action = #selector(toolbarItemButtonAction(_:))
        }
        
        return toolbarItem
    }
    
    func toolbarItemButtonAction(_ sender: NSButton) {
        let tag = sender.tag
        switch tag {
        case 0:
            mAppDelegate().AppWindowControllers().first?.showWindow(nil)
        case 1:
            let bookChapters = BookChaptersViewController()
            let pop = NSPopover.init()
            pop.behavior = .semitransient
            pop.contentViewController = bookChapters
            pop.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
        case 5:
            let bookSetting = BookSettingViewController()
            let pop = NSPopover.init()
            pop.behavior = .semitransient
            pop.delegate = self
            bookSetting.popover = pop
            pop.contentViewController = bookSetting
            pop.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
        default:
            print("\(tag)")
        }
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

extension ReadWindowController: NSPopoverDelegate {
    func popoverDidClose(_ notification: Notification) {
        let pop = notification.object as! NSPopover
        let add = pop.contentViewController as! BookSettingViewController
        add.popover = nil
    }
}
