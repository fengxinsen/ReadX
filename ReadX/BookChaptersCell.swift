//
//  BookChaptersCell.swift
//  ReadX
//
//  Created by video on 2017/3/20.
//  Copyright © 2017年 Von. All rights reserved.
//

import Cocoa

class BookChaptersCell: NSTableCellView {

    @IBOutlet weak var mTitle: NSTextField!
    
    var mBookChapter: BookChapter! {
        didSet {
            mTitle.stringValue = mBookChapter.chapterDesc
        }
    }
    
    override var backgroundStyle: NSBackgroundStyle {
        didSet {
            if backgroundStyle == .light {
                let color = NSColor.white
                self.backgroundColor = color
                mTitle.backgroundColor = color
            } else if self.backgroundStyle == .dark {
                let color = NSColor.gray
                self.backgroundColor = color
                mTitle.backgroundColor = color
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
