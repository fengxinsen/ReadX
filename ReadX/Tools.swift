//
//  Tools.swift
//  ReadX
//
//  Created by video on 2017/3/15.
//  Copyright © 2017年 Von. All rights reserved.
//

import Foundation
import Cocoa

extension NSView {
    
    var backgroundColor: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor.init(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
}

extension NSString {
    
    /// 字符串匹配正则
    ///
    /// - Parameter pattern: 正则
    /// - Returns: String
    func pattern(pattern: String) -> String {
        let reg = try! NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
        let rang = NSRange.init(location: 0, length: self.length)
        let firstRange = reg.rangeOfFirstMatch(in: self as String, options: .reportProgress, range: rang)
        var regString: String = ""
        if !NSEqualRanges(firstRange, NSRange.init(location: NSNotFound, length: 0)) {
            regString = self.substring(with: firstRange)
        }
        return regString
    }
    
    /// 字符串匹配正则
    ///
    /// - Parameter pattern: 正则
    /// - Returns: String
    func have(pattern: String) -> Bool {
        let reg = try! NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
        let rang = NSRange.init(location: 0, length: self.length)
        let number = reg.numberOfMatches(in: self as String, options: .reportProgress, range: rang)
        return number > 0
    }
}

extension String {
    
    /// 取字符串前几位支付
    ///
    /// - Parameter offsetBy: 几位
    /// - Returns: String
    func offsetBy(offsetBy: String.IndexDistance) -> String {
        let index = self.index(self.startIndex, offsetBy: offsetBy)
        return self.substring(to: index)
    }
    
    /// 链接格式化
    ///
    /// - Parameters:
    ///   - book: Book
    ///   - strUrl: 链接
    /// - Returns: String
    func urlBookNumberAndPre2Foxmart(book: Book) -> String {
        var value = self
        let bookNumber = book.bookNumber
        let Pre2 = book.pre2
        if (value.contains("bookNumber")) {
            value = value.replacingOccurrences(of: "bookNumber", with: bookNumber)
        }
        if (value.contains("Pre2")) {
            value = value.replacingOccurrences(of: "Pre2", with: Pre2)
        }
        return value
    }
    
    func urlXPathFoxmart(xpath: String) -> String {
        var value = self
        if (value.contains("xpath")) {
            value = value.replacingOccurrences(of: "xpath", with: xpath)
        }
        return value
    }
}

extension String {
    
    var floatValue: Float {
        let temp = NSString.init(string: self)
        return temp.floatValue
    }
    
    var CGFloatValue: CGFloat {
        let temp = NSString.init(string: self)
        return CGFloat.init(temp.floatValue)
    }
}

extension CGFloat {
    
    var stringValue: String {
        return self.description
    }
    
    var floatValue: Float {
        return Float(self)
    }
}

extension Data {
    
    /// 检测编码 gbk or utf8
    ///
    /// - Returns: String.Encoding
    func detectedEncoding() -> String.Encoding {
        let encodingPriority = [
            String.Encoding.init(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))), //gbk
            String.Encoding.utf8 //utf8
        ]
        var encode: String.Encoding?
        for enc in encodingPriority {
            let str = NSString.init(data: self, encoding: enc.rawValue)
            let range = str?.range(of: "</html>", options: .caseInsensitive)
            if (str != nil) && range?.location != NSNotFound {
                encode = enc
            }
        }
//        print("编码 = \(encode)")
        return encode!
    }
}

/*
 字体 间距的倍数 等
 */
struct TypeStyle {
    var font: NSFont = NSFont.systemFont(ofSize: 14)
    var firstLineHeadIndentMultiple: CGFloat = 2
    var paragraphSpacingMultiple: CGFloat = 4
    var paragraphSpacingBeforeMultiple: CGFloat = 4
    var headIndentMultiple: CGFloat = 0
    var tailIndentMultiple: CGFloat = 0
    var lineSpacingMultiple: CGFloat = 4
    var kernAttributeMultiple: CGFloat = 0
}

extension String {
    
    func reType(_ typeStyle: TypeStyle) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        
        let font = typeStyle.font
        //首行缩进
        paragraphStyle.firstLineHeadIndent = font.pointSize * typeStyle.firstLineHeadIndentMultiple
        //段落后面的间距
        paragraphStyle.paragraphSpacing = font.pointSize / typeStyle.paragraphSpacingMultiple
        //段落之前的间距
        paragraphStyle.paragraphSpacingBefore = font.pointSize / typeStyle.paragraphSpacingBeforeMultiple
        //左边距
        paragraphStyle.headIndent = font.pointSize * typeStyle.headIndentMultiple
        //右边距
        paragraphStyle.tailIndent = -font.pointSize * typeStyle.tailIndentMultiple
        //行间距
        paragraphStyle.lineSpacing = font.pointSize / typeStyle.lineSpacingMultiple
        //字间距
        let kern = font.pointSize * typeStyle.kernAttributeMultiple
        
//        print(paragraphStyle)
        
        let attrs: [String : Any] = [NSParagraphStyleAttributeName: paragraphStyle,
                                     NSFontAttributeName: font,
                                     NSKernAttributeName: kern,
                                     NSBackgroundColorAttributeName: NSColor.clear]
        
        return NSAttributedString.init(string: self, attributes: attrs)
    }
    
    func reType(attributes attrs: [String : Any]? = nil) -> NSAttributedString {
        return NSAttributedString.init(string: self, attributes: attrs)
    }
}
