//
//  BookChapters.swift
//  ReadX
//
//  Created by video on 2017/3/20.
//  Copyright © 2017年 Von. All rights reserved.
//

import Cocoa

class BookChaptersViewController: BaseViewController {

    @IBOutlet weak var mTableView: NSTableView!
    
    fileprivate var datas = [BookChapter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        datas.removeAll()
        let book = Single.shareSingle.currentBook
        datas = (book?.bookChapters)!
        self.mTableView.reloadData()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        let chapter = Single.shareSingle.currentBookChapter
//        mTableView.selectRowIndexes(IndexSet.init(integer: (chapter?.chapterIndex)!), byExtendingSelection: false)
        mTableView.scrollRowToVisible((chapter?.chapterIndex)!)
    }
    
    @IBAction func tableViewAction(_ sender: NSTableView) {
        let row = sender.selectedRow
//        sender.deselectRow(row)//取消选中
        if row >= 0 && row < datas.count {
            let data = self.datas[row]
            toChapter(bookChapter: data)
        }
    }
}

extension BookChaptersViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.datas.count
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
//        let tableView = notification.object as! NSTableView
//        let row = tableView.selectedRow
//        let data = self.datas[row]
//        print(row)
//
//        toChapter(book: data)
    }
    
    func toChapter(bookChapter: BookChapter) {
        NotificationCenter.default.post(name: Book_Chapter_Notification, object: bookChapter)
    }
    
}

extension BookChaptersViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let data = self.datas[row]
        let view = tableView.make(withIdentifier: "BookChaptersCell", owner: self) as! BookChaptersCell
        view.mBookChapter = data;
        return view
    }
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        print(tableColumn.identifier)
    }
    func tableView(_ tableView: NSTableView, mouseDownInHeaderOf tableColumn: NSTableColumn) {
        print(tableView.selectedRow)
    }
}
