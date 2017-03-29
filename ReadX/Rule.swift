//
//  Rule.swift
//  ReadX
//
//  Created by video on 2017/3/3.
//  Copyright © 2017年 Von. All rights reserved.
//

import Foundation

import HandyJSON

struct Rule: HandyJSON{
    var version: String?
    var rules: [RuleData]?
}

struct RuleData: HandyJSON {
    var site: String?
    var host: String?
    var bookUrlReg: String?
    var bookNumberReg: String?
    var nameRule: RuleItem?
    var imgRule: RuleItem?
    var chaptersRule: RuleItem?
    var contentRule: RuleItem?
}

struct RuleItem: HandyJSON {
    var sourceUrl: String?
    var xpath: String?
    var value: String?
}

private let localRulePath = Bundle.main.path(forResource: "rule", ofType: "json")

internal func localRule() -> Rule {
    var rule: Rule?
    do {
        let json: String = try String.init(contentsOfFile: localRulePath!)
        if let temp = Rule.deserialize(from: json) {
//            print("\(temp)")
            rule = temp
        }
    } catch {
        print(error)
    }
    return rule!
}

func checkRule() -> Rule {
    var local_rule = localRule()
    let url = URL.init(string: "https://github.com/fengxinsen/ReadX/raw/master/Rule/rule.json")
    do {
        let json = try String.init(contentsOf: url!)
        if let rule = Rule.deserialize(from: json) {
            let local_rule_version = local_rule.version
            let net_rule_version = rule.version
            if NSString.init(string: net_rule_version!).doubleValue > NSString.init(string: local_rule_version!).doubleValue {
                print("net_version=\(String(describing: rule.version))")
                local_rule = rule
                try json.write(toFile: localRulePath!, atomically: true, encoding: .utf8)
            } else {
                print("rule version \(String(describing: local_rule.version)) 无更新")
            }
        }
    } catch {
        print(error)
    }
    return local_rule
}
