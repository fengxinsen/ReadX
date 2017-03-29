//
//  XViewController.swift
//  ReadX
//
//  Created by video on 2017/2/21.
//  Copyright © 2017年 Von. All rights reserved.
//

import Cocoa

import Kanna

class BookRoomViewController: BaseViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Book_RoomRefresh_Notification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Book_RoomChaptersRefresh_Notification, object: nil)
    }
    
    lazy var readWC: BaseWindowController = {
        return BaseWindowController()
    }()
    
    internal var datas = [Book]()
    
    @IBOutlet weak var mTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addBook(bookUrl: "http://baishuzhai.com/ibook/30/30144/")
//        addBook(bookUrl: "http://www.qu.la/book/24868/")
        
        NotificationCenter.default.addObserver(self, selector: #selector(notification(notification:)), name: Book_RoomRefresh_Notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notification(notification:)), name: Book_RoomChaptersRefresh_Notification, object: nil)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        loadData()
    }
    
    func notification(notification: Notification) {
        if notification.name == Book_RoomRefresh_Notification {
            loadData()
        } else if notification.name == Book_RoomChaptersRefresh_Notification {
            loadData()
        }
    }
    
    @IBAction func tableViewAction(_ sender: NSTableView) {
        let row = sender.selectedRow
        print(row)
        if row >= 0 && row < datas.count {
            let data = self.datas[row]
            
            openBook(book: data)
        }
    }
}

extension BookRoomViewController: NSTableViewDataSource {
    
    func loadData() {
        datas.removeAll()
        let books = sqlite.readData()
        books.forEach { (book) in
            getBook(book: book, callBack: { (book) in
                self.datas.append(book)
                self.mTableView.reloadData()
                
            })
        }
    }
    
    func refreshData() {
        datas.removeAll()
        let books = sqlite.readData()
        books.forEach { (book) in
            BookChapters(book: book, callBack: { (chapters) in
                var temp = book
                temp.bookChapters = chapters
                self.datas.append(book)
                self.mTableView.reloadData()
            })
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.datas.count
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
//        let tableView = notification.object as! NSTableView
//        let row = tableView.selectedRow
//        let data = self.datas[row]
//        print(row)
//        
//        openBook(book: data)
    }
}

extension BookRoomViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let data = self.datas[row]
        let view = tableView.make(withIdentifier: "BookRoomCell", owner: self) as! BookRoomCell
        view.mBook = data;
        return view
    }
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        print(tableColumn.identifier)
    }
    func tableView(_ tableView: NSTableView, mouseDownInHeaderOf tableColumn: NSTableColumn) {
        print(tableView.selectedRow)
    }
}
