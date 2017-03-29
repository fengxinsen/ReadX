//
//  BookRoomCell.swift
//  ReadMe
//
//  Created by video on 2017/2/20.
//  Copyright © 2017年 video. All rights reserved.
//

import Cocoa

import Kingfisher

class BookRoomCell: NSTableCellView {

    @IBOutlet weak var mBookDelBtn: NSButtonCell!
    @IBOutlet weak var mImageView: NSImageView!
    @IBOutlet weak var mBookName: NSTextField!
    @IBOutlet weak var mBookReadNew: NSTextField!
    
    var mBook: Book! {
        didSet {
            mBookName.stringValue = mBook.bookName
            let chapter = mBook.bookReadNew
            mBookReadNew.stringValue = "最新：" + chapter
            let url = URL.init(string: mBook.bookImage)
            mImageView.kf.setImage(with: ImageResource.init(downloadURL: url!))
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        cellMenu()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    @IBAction func bookDelAction(_ sender: NSButtonCell) {
        deleteBook(book: mBook)
    }
}

extension BookRoomCell {
    
    func cellMenu() {
        let menu = NSMenu.init()
        menu.addItem(NSMenuItem.init(title: "打开", action: #selector(openAction(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.init(title: "删除", action: #selector(delAction(_:)), keyEquivalent: ""))
        self.menu = menu
    }
    
    func openAction(_ sender: NSMenuItem) {
        openBook(book: mBook)
    }
    
    func delAction(_ sender: NSMenuItem) {
        deleteBook(book: mBook)
    }
}
