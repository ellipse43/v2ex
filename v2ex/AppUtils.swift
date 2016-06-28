//
//  Utils.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/16.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel

struct Config {
    static let appName = "v2ex"
    static let tabMenus = [("技术", "tech"), ("创意", "creative"), ("好玩", "play"), ("Apple", "apple"), ("酷工作", "jobs"), ("交易", "deals"), ("城市", "city"), ("问与答", "qna"), ("最热", "hot"), ("全部", "all"), ("R2", "r2"), ("节点", "nodes")]
    static let tabUrl = "http://www.v2ex.com/?tab=%@"
    static let replyURL = "http://www.v2ex.com/api/replies/show.json"
    static let topicURL = "http://www.v2ex.com/api/topics/show.json"
    static let memberURL = "http://www.v2ex.com/api/members/show.json"
}

struct Color {
    static let basic = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
    static let black = UIColor.blackColor()
}

struct Font {
    static let basic = UIFont(name: "Helvetica Neue", size: 12)
}

struct Factory {
    
    static func createBasicLabel() -> UILabel {
        let v = UILabel()
        v.font = UIFont(name: "Helvetica Neue", size: 12)
        v.textColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
        return v
    }
    
    static func createQuotationLabel(text: String) -> UILabel {
        let v = UILabel()
        v.font = UIFont(name: "Helvetica Neue", size: 28)
        v.text = text
        return v
    }
    
    static func createActiveLabel() -> ActiveLabel {
        let v = ActiveLabel()
//        v.mentionEnabled = true
//        v.URLEnabled = true
        v.mentionColor = Color.basic
        v.mentionSelectedColor = Color.basic
        v.URLColor = Color.basic
        v.URLSelectedColor = Color.basic
        v.lineSpacing = 2
        v.lineBreakMode = NSLineBreakMode.ByWordWrapping
        v.numberOfLines = 0
        return v
    }
}

struct Util {
    static func timePrettify(t: Double) -> String {
        let sec = Int(NSDate().timeIntervalSince1970 - t)
        var msg = ""
        switch sec {
        case 0..<10:
            msg = "刚刚"
        case 10..<60:
            msg = "\(sec)秒前"
        case 60..<3600:
            msg = "\(sec / 60)分钟前"
        case 3600..<216000:
            msg = "\(sec / 3600)小时前"
        default:
            msg = "\(sec / 216000)天前"
        }
        return msg
    }
}

