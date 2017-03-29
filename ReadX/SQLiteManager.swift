//
//  BookSQLiteManager.swift
//  ReadX
//
//  Created by video on 2017/3/14.
//  Copyright © 2017年 Von. All rights reserved.
//

import Foundation

import SQLite

// MARK: model
/// 章节
struct BookChapter {
    var chapterIndex: Int = 0
    var chapterDesc: String = ""
    var chapterUrl: String = ""
}
/// 书
struct Book {
    var bookId: String = ""
    var bookUrl: String = ""
    var bookName: String = ""
    var bookImage: String = ""
    var bookReadNew: String = ""
    var bookReadLast: String = "0"
    
    var bookRule: RuleData?
    var bookNumber: String = ""
    var pre2: String = ""
    var bookChapters: [BookChapter]?
}

let c_bookName = Expression<String>("bookName")  //书名
let c_bookImage = Expression<String>("bookImage")  //图片链接
let c_bookReadNew = Expression<String>("bookReadNew")  //章节名
let c_bookReadLast = Expression<String>("bookReadLast")  //章节位置

struct BookSQLiteManager {
    
    private var db: Connection!
    private let t_books = Table("books") //表名
    private let c_id = Expression<Int64>("id")//主键
    private let c_bookUrl = Expression<String>("bookUrl")  //链接 包含章节目录的链接
    
    init() {
        createdsqlite3()
    }
    
    //创建数据库文件
    mutating func createdsqlite3() {
        let path = Bundle.main.path(forResource: "db", ofType: "sqlite3")
        if FileManager.default.fileExists(atPath: path!) {
            do {
                db = try Connection(path!)
                try db.run(t_books.create(temporary: false, ifNotExists: true, block: { (t) in
                    t.column(c_id, primaryKey: PrimaryKey.autoincrement)
                    t.column(c_bookUrl, unique: true)
                    t.column(c_bookName, defaultValue: "")
                    t.column(c_bookImage, defaultValue: "")
                    t.column(c_bookReadNew, defaultValue: "0")
                    t.column(c_bookReadLast, defaultValue: "0")
                }))
            } catch {
                print("con >>> \(error)")
            }
        }
    }
    
    //插入数据
    func insertData(_bookUrl: String, _bookReadLast: String = "0", _bookReadNew: String = "0") -> Bool {
        var isOK = false
        do {
            let insert = t_books.insert(c_bookUrl <- _bookUrl, c_bookReadLast <- _bookReadLast, c_bookReadNew <- _bookReadNew)
            try db.run(insert)
            isOK = true
        } catch {
            print("insert >>> \(error)")
        }
        return isOK
    }
    
    //读取数据
    func readData() -> [Book] {
        var bookData = Book()
        var bookDataArr = [Book]()
        for book in try! db.prepare(t_books) {
            bookData.bookId = String(book[c_id])
            bookData.bookUrl = book[c_bookUrl]
            bookData.bookName = book[c_bookName]
            bookData.bookImage = book[c_bookImage]
            bookData.bookReadNew = book[c_bookReadNew]
            bookData.bookReadLast = book[c_bookReadLast]
            print("readData \(bookData)")
            bookDataArr.append(bookData)
        }
        return bookDataArr
    }
    
    //更新数据
    func updateData(bookId: String, key: Expression<String>, value: String) -> Bool {
        var isOK = false
        let id = Int64.init(bookId)!
        let currBook = t_books.filter(c_id == id)
        do {
            try db.run(currBook.update(key <- value))// 1
            isOK = true
        } catch {
            print("update >>> \(error)")
        }
        return isOK
    }
    func updateBook(book: Book) -> Bool {
        var isOK = false
        let id = Int64.init(book.bookId)!
        let currBook = t_books.filter(c_id == id)
        do {
            try db.run(currBook.update(c_bookName <- book.bookName, c_bookImage <- book.bookImage, c_bookReadNew <- book.bookReadNew, c_bookReadLast <- book.bookReadLast))// 1
            isOK = true
        } catch {
            print("update book >>> \(error)")
        }
        return isOK
    }
    
    //删除数据
    func delData(bookId: String) -> Bool {
        var isOK = false
        let id = Int64.init(bookId)!
        let currBook = t_books.filter(c_id == id)
        do {
            try db.run(currBook.delete())
            isOK = true
        } catch {
            print("delete >>> \(error)")
        }
        return isOK
    }
}
