//
//  BookAddViewController.swift
//  ReadX
//
//  Created by video on 2017/3/17.
//  Copyright © 2017年 Von. All rights reserved.
//

import Cocoa

class BookAddViewController: BaseViewController {
    
    var popover: NSPopover?
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var comboBox: NSComboBox!
    @IBOutlet weak var msg: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addBook(bookUrl: "http://baishuzhai.com/ibook/30/30144/")
//        addBook(bookUrl: "http://www.qu.la/book/24868/")
        
        var items = [String]()
        BookRule.rules?.forEach { (rd) in
            items.append(rd.site!)
        }
        comboBox.addItems(withObjectValues: items)
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        popover?.close()
    }
    
    @IBAction func clickAction(_ sender: NSButton) {
        let url = textField.stringValue
        if url.characters.count > 0 {
            if addBook(bookUrl: url) {
                print("添加成功")
                msg.stringValue = "添加成功"
                NotificationCenter.default.post(name: Book_RoomRefresh_Notification, object: nil)
//                popover?.close()
            } else {
                print("添加错误")
                msg.stringValue = "添加错误"
            }
        }
    }
}
