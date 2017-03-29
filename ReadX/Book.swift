//
//  Book.swift
//  ReadX
//
//  Created by video on 2017/2/23.
//  Copyright © 2017年 Von. All rights reserved.
//

import Foundation

import Kanna
import Kingfisher

// MARK: Rule
let BookRule: Rule = {
    let app = NSApplication.shared().delegate as! AppDelegate
    return app.bookRule!
}()
internal func currentRule(bookUrl: String) -> RuleData? {
    let url = URL.init(string: bookUrl)
    let curRule = BookRule.rules?.filter({ (rd) -> Bool in
        return rd.host == url?.host
    })
    if (curRule?.count)! > 0 {
        print("有此Rule \(String(describing: curRule?.first?.host))")
    } else {
        print("无此Rule \(bookUrl)")
    }
    return curRule?.first
}

// MARK: 数据库 db.sqlite3
internal let sqlite = BookSQLiteManager()

// MARK: DispatchQueue
let DQ = DispatchQueue.init(label: "BOOK", qos: .utility)

// 获取书的信息
func getBook(book: Book, callBack: @escaping (_ book: Book) -> Void) {
    DQ.async {
        var temp = book
        let bookUrl = temp.bookUrl
        let rule = currentRule(bookUrl: bookUrl)
        if (rule != nil) {
            temp.bookUrl = bookUrl
            temp.bookRule = rule
            
            //bookNumber Pre2
            let bookNumberReg = rule?.bookNumberReg
            let str = bookUrl as NSString
        
            let bookNumber: String = str.pattern(pattern: bookNumberReg!)
            let Pre2: String = bookNumber.offsetBy(offsetBy: 2)
            print("bookNumber = \(bookNumber)")
            print("Pre2 = \(Pre2)")
            temp.bookNumber = bookNumber
            temp.pre2 = Pre2
            
            let temp_name_url = rule?.nameRule?.sourceUrl?.urlBookNumberAndPre2Foxmart(book: temp)
            let temp_image_url = rule?.imgRule?.sourceUrl?.urlBookNumberAndPre2Foxmart(book: temp)
            let temp_chapters_url = rule?.chaptersRule?.sourceUrl?.urlBookNumberAndPre2Foxmart(book: temp)
            
            do {
                let data = try Data.init(contentsOf: URL.init(string: bookUrl)!)
                let encode = data.detectedEncoding()
                if let doc = HTML(html: data, encoding: encode) {
                    
                    if bookUrl == temp_name_url {
                        let name = getBookName(book: temp, doc: doc)
                        temp.bookName = name
                    } else {
                        let name = getBookName(book: temp, data: data)
                        temp.bookName = name
                    }
                    if temp_name_url == temp_image_url {
                        let imageUrl = getBookImageUrl(book: temp, doc: doc)
                        temp.bookImage = imageUrl
                    } else {
                        let imageUrl = getBookImageUrl(book: temp, data: data)
                        temp.bookImage = imageUrl
                    }
                    var chapters: [BookChapter]?
                    if temp_name_url == temp_chapters_url {
                        chapters = getBookChapters(book: temp, doc:doc)
                    } else {
                        chapters = getBookChapters(book: temp, data: data)
                    }
                    temp.bookChapters = chapters
                    let last = chapters?.last?.chapterDesc
                    temp.bookReadNew = last!
                    if sqlite.updateBook(book: temp) {
                        print("更新book \(temp.bookName)")
                    }
                }
            } catch  {
                print(error)
            }
            //UI
            DispatchQueue.main.async {
                callBack(temp)
            }
        }
    }
}

// MARK: 书名
fileprivate func getBookName(book: Book, data: Data) -> String {
    var value: String = ""
    let encode = data.detectedEncoding()
    if let doc = HTML(html: data, encoding: encode) {
        value = getBookName(book: book, doc: doc)
    }
    print("name value = \(value)")
    return value
}
fileprivate func getBookName(book: Book, doc: HTMLDocument) -> String {
    var value: String = ""
    let rule = book.bookRule
    let temp_xpath = rule!.nameRule?.xpath
    let temp_value = rule!.nameRule?.value
    
    let name = doc.at_xpath(temp_xpath!)?.text
    
    value = (temp_value?.urlBookNumberAndPre2Foxmart(book: book))!
    value = value.urlXPathFoxmart(xpath: name!)
    return value
}

// MARK: 封面
fileprivate func getBookImageUrl(book: Book, data: Data) -> String {
    var value: String = ""
    let encode = data.detectedEncoding()
    if let doc = HTML(html: data, encoding: encode) {
        value = getBookImageUrl(book: book, doc: doc)
    }
    print("image value = \(value)")
    return value
}
fileprivate func getBookImageUrl(book: Book, doc: HTMLDocument) -> String {
    var value: String = ""
    let rule = book.bookRule
    let temp_xpath = rule!.imgRule?.xpath
    let temp_value = rule!.imgRule?.value
    
    let img = doc.at_xpath(temp_xpath!)?.text
    
    value = (temp_value?.urlBookNumberAndPre2Foxmart(book: book))!
    value = value.urlXPathFoxmart(xpath: img!)
    return value
}


// MARK: 目录
fileprivate func getBookChapters(book: Book, data: Data) -> [BookChapter] {
    var contents = [BookChapter]()
    let encode = data.detectedEncoding()
    if let doc = HTML(html: data, encoding: encode) {
        contents = getBookChapters(book: book, doc: doc)
    }
    return contents
}
fileprivate func getBookChapters(book: Book, doc: HTMLDocument) -> [BookChapter] {
    var chapters = [BookChapter]()
    let rule = book.bookRule
    let temp_xpath = rule!.chaptersRule?.xpath
    let temp_value = rule!.chaptersRule?.value
    
    let temp_arr = temp_xpath?.components(separatedBy: " ")// 空格分割
    let div_lists = doc.xpath((temp_arr?.first!)!)
    
    for div_a in div_lists.enumerated() {
        var chapter = BookChapter()
        let href = div_a.element.at_xpath((temp_arr?.last)!)?.text
        let desc = div_a.element.text
        chapter.chapterIndex = div_a.offset
        chapter.chapterDesc = desc!
        var value = temp_value
        value = value?.urlBookNumberAndPre2Foxmart(book: book)
        value = value?.urlXPathFoxmart(xpath: href!)
//        print("chapter \(div_a.offset) value = \(value)")
        chapter.chapterUrl = value!
        chapters.append(chapter)
    }
    return chapters
}

// MARK: 获取目录
func BookChapters(book: Book, callBack: @escaping ([BookChapter]) -> Void) {
    DQ.async {
        var contents = [BookChapter]()
        let rule = book.bookRule
        let chapters_url = rule?.chaptersRule?.sourceUrl?.urlBookNumberAndPre2Foxmart(book: book)
        do {
            let data = try Data.init(contentsOf: URL.init(string: chapters_url!)!)
            let encode = data.detectedEncoding()
            if let doc = HTML(html: data, encoding: encode) {
                contents = getBookChapters(book: book, doc: doc)
                //更新最新章节
                let new = contents.last?.chapterDesc
                if sqlite.updateData(bookId: book.bookId, key: c_bookReadNew, value: new!) {
                    print("更新 \(book.bookName) 最新章节 \(String(describing: new))")
                }
            }
        } catch {
            print(error)
        }
        DispatchQueue.main.async {
            callBack(contents)
        }
    }
}

// MARK: 章节正文内容
func BookChapterContent(book: Book, chapter: BookChapter, callBack: @escaping (String) -> Void) {
    print("查询 \(chapter)")
    //最后阅读 存数据库
    guard sqlite.updateData(bookId: book.bookId, key: c_bookReadLast, value: String(chapter.chapterIndex)) else {
        print("更新最后阅读 失败")
        return
    }
    
    DQ.async {
        let rule = book.bookRule
        let chapterUrl = chapter.chapterUrl
        var str: String?
        do {
            let data = try Data.init(contentsOf: URL.init(string: chapterUrl)!)
            let encode = data.detectedEncoding()
            
            if let doc = HTML(html: data, encoding: encode) {
                let temp_xpath = rule?.contentRule?.xpath
                
                let content = doc.at_xpath(temp_xpath!)
                //内容所在节点
//                print("\(content?.toHTML!)")
                for tag in (content?.xpath("*"))! {
                    if tag.tagName! == "div" || tag.tagName! == "script" || tag.tagName! == "p" || tag.tagName! == "br" {
                        content?.removeChild(tag)
//                        print("已去除节点" + tag.tagName! + "\n>>>" + tag.toHTML!)
                    }
                }
                //去除首尾空格
                str = content?.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                //原空格缩进 替换为换行 \n
                if (str?.contains("    "))! {
                    str = str?.replacingOccurrences(of: "    ", with: "\n")
                }
                if (str?.contains("  "))! {
                    str = str?.replacingOccurrences(of: "  ", with: "\n")
                }
            }
        } catch  {
            print(error)
        }
        DispatchQueue.main.async {
            callBack(str!)
        }
    }
}

