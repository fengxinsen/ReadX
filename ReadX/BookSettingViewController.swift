//
//  BookSettingViewController.swift
//  ReadX
//
//  Created by video on 2017/3/20.
//  Copyright © 2017年 Von. All rights reserved.
//

import Cocoa

class BookSettingViewController: BaseViewController {
    
    var popover: NSPopover?
    
    @IBOutlet weak var fontSize: NSTextField!
    @IBOutlet weak var firstLineHeadIndent: NSTextField!
    @IBOutlet weak var paragraphSpacingBefore: NSTextField!
    @IBOutlet weak var paragraphSpacing: NSTextField!
    @IBOutlet weak var headIndent: NSTextField!
    @IBOutlet weak var tailIndent: NSTextField!
    @IBOutlet weak var lineSpacing: NSTextField!
    @IBOutlet weak var kern: NSTextField!
    
    fileprivate var typeStyle: TypeStyle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeStyle = Single.shareSingle.currentTypeStyle
        
        fontSize.stringValue = (typeStyle?.font.pointSize.stringValue)!
        firstLineHeadIndent.stringValue = (typeStyle?.firstLineHeadIndentMultiple.stringValue)!
        paragraphSpacingBefore.stringValue = (typeStyle?.paragraphSpacingBeforeMultiple.stringValue)!
        paragraphSpacing.stringValue = (typeStyle?.paragraphSpacingMultiple.stringValue)!
        headIndent.stringValue = (typeStyle?.headIndentMultiple.stringValue)!
        tailIndent.stringValue = (typeStyle?.tailIndentMultiple.stringValue)!
        lineSpacing.stringValue = (typeStyle?.lineSpacingMultiple.stringValue)!
        kern.stringValue = (typeStyle?.kernAttributeMultiple.stringValue)!
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        popover?.close()
    }
    
    @IBAction func confirmAction(_ sender: NSButton) {
        typeStyle?.font = NSFont.systemFont(ofSize: fontSize.stringValue.CGFloatValue)
        typeStyle?.firstLineHeadIndentMultiple = firstLineHeadIndent.stringValue.CGFloatValue
        typeStyle?.paragraphSpacingBeforeMultiple = paragraphSpacingBefore.stringValue.CGFloatValue
        typeStyle?.paragraphSpacingMultiple = paragraphSpacing.stringValue.CGFloatValue
        typeStyle?.headIndentMultiple = headIndent.stringValue.CGFloatValue
        typeStyle?.tailIndentMultiple = tailIndent.stringValue.CGFloatValue
        typeStyle?.lineSpacingMultiple = lineSpacing.stringValue.CGFloatValue
        typeStyle?.kernAttributeMultiple = kern.stringValue.CGFloatValue
        
        Single.shareSingle.currentTypeStyle = typeStyle!
        ud()
        let udx = UserDefaults.standard.object(forKey: "TypeStyle")
        print("\(String(describing: udx))")
        
        NotificationCenter.default.post(name: Book_TypeStyle_Notification, object: nil)
        
        popover?.close()
    }
    func ud() {
        UserDefaults.standard.set(typeStyle.debugDescription, forKey: "TypeStyle")
    }
}
