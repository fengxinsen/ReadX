//
//  BookSingle.swift
//  ReadX
//
//  Created by video on 2017/3/20.
//  Copyright © 2017年 Von. All rights reserved.
//

import Foundation
import Cocoa

// MARK: Notification
let Book_RoomRefresh_Notification = Notification.Name.init("Book_RoomRefresh_Notification")
let Book_RoomChaptersRefresh_Notification = Notification.Name.init("Book_RoomChaptersRefresh_Notification")
let Book_Chapter_Notification = Notification.Name.init("Book_Chapter_Notification")
let Book_TypeStyle_Notification = Notification.Name.init("Book_TypeStyle_Notification")

// MARK: 添加书籍
func addBook(bookUrl: String) -> Bool {
    
    let rule = currentRule(bookUrl: bookUrl)
    if bookUrl.have(pattern: (rule?.bookUrlReg)!) {
        print("Rule 有")
    } else {
        print("Rule 无")
    }
    return sqlite.insertData(_bookUrl: bookUrl)
}

// MARK: open
func openBook(book: Book) {
    let readX = ReadWindowController()
    Single.shareSingle.currentBook = book
    let read = ReadBookViewController()
    readX.contentViewController = read
    
    let app = NSApplication.shared().delegate as! AppDelegate
    let readWC = app.addWindowController(aWindowController: readX)
    app.firstWindowController().close()
    readWC.showWindow(nil)
}

// MARK: delete
func deleteBook(book: Book) {
    if sqlite.delData(bookId: book.bookId) {
        NotificationCenter.default.post(name: Book_RoomRefresh_Notification, object: nil)
    }
}

// MARK: Single
class Single {
    
    static let shareSingle = Single()
    
    var currentBook: Book?
    
    var currentBookChapter: BookChapter?
    
    var currentTypeStyle = TypeStyle()
    
    func clear() {
        currentBook = nil
        currentBookChapter = nil
        currentTypeStyle = TypeStyle()
    }
}

