//
//  ReadXViewController.swift
//  ReadX
//
//  Created by video on 2017/2/21.
//  Copyright © 2017年 Von. All rights reserved.
//

import Cocoa

import Kanna

protocol ReadBookTextViewKeyDwonDelegate {
    func readBookTextViewKeyDown(aEvent: NSEvent)
}

class ReadBookTextView: NSTextView {
    var readBookTextViewKeyDwonDelegate: ReadBookTextViewKeyDwonDelegate?
    //响应键盘事件
    override var acceptsFirstResponder: Bool {
        return true
    }
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 123 || event.keyCode == 124 || event.keyCode == 49{
            readBookTextViewKeyDwonDelegate?.readBookTextViewKeyDown(aEvent: event)
        } else {
            super.keyDown(with: event)
        }
    }
}

class ReadBookViewController: BaseViewController, ReadBookTextViewKeyDwonDelegate {
    
    deinit {
        print("rb xxx")
        NotificationCenter.default.removeObserver(self, name: Book_Chapter_Notification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Book_TypeStyle_Notification, object: nil)
    }
    
    @IBOutlet var mScrollView: NSScrollView!
    @IBOutlet var mTextView: ReadBookTextView!
    
    fileprivate var book: Book?
    
    var book_chapter_index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        mTextView.readBookTextViewKeyDwonDelegate = self
        mScrollView.verticalPageScroll = mTextView.bounds.size.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(notification(notification:)), name: Book_Chapter_Notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notification(notification:)), name: Book_TypeStyle_Notification, object: nil)
        
        book = Single.shareSingle.currentBook
        
        lastChapter()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
    
    func notification(notification: Notification) {
        let name = notification.name
        switch name {
        case Book_Chapter_Notification:
            let bc = notification.object as! BookChapter
            book_chapter_index = bc.chapterIndex
            bookChapter(index: book_chapter_index)
        case Book_TypeStyle_Notification:
            let str = mTextView.textStorage?.string
            contentTypeStyle(string: str!)
        default:
            print("\(notification)")
        }
        
    }
    
    internal func readBookTextViewKeyDown(aEvent: NSEvent) {
        switch aEvent.keyCode {
        case 124:
            print("右")
            if book_chapter_index < (book?.bookChapters?.count)! {
                book_chapter_index = book_chapter_index + 1
                bookChapter(index: book_chapter_index)
            }
        case 123:
            print("左")
            if book_chapter_index >= 0 {
                book_chapter_index = book_chapter_index - 1
                bookChapter(index: book_chapter_index)
            }
        case 49:
            print("空格")
            print("\(mTextView.frame)")
//            mTextView.scrollToVisible(NSRect.init(x: 0, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>))
            mTextView.scroll(NSPoint(x: 1, y: mTextView.frame.size.height))
        default:
            print(aEvent.keyCode)
        }
    }
    
    func lastChapter() {
        book_chapter_index = Int((book?.bookReadLast)!)!
        bookChapter(index: book_chapter_index)
    }
    
    func bookChapter(index: Int) {
        let chapter = book!.bookChapters?[index]
        var title = book!.bookName + " "
        let num = (chapter?.chapterIndex.description)! + " "
        print("num = \(num)")
        title += num
        title += (chapter?.chapterDesc)!
        
        book?.bookReadLast = String(index)
        Single.shareSingle.currentBook?.bookReadLast = String(index)
        Single.shareSingle.currentBookChapter = chapter
        
        weak var weakSelf = self
        BookChapterContent(book: book!, chapter: chapter!) { (string) in
            weakSelf?.view.window?.title = title
            weakSelf?.contentTypeStyle(string: string)
        }
    }
    
    func contentTypeStyle(string: String) {
        let typeStyle = Single.shareSingle.currentTypeStyle
        let attStr = string.reType(typeStyle)
        mTextView.textStorage?.setAttributedString(attStr)
        mTextView.scroll(NSPoint.init(x: 0, y: 0))
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
