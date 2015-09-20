//
//  Utils.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/16.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import Foundation

struct Config {
    static let appName = "v2ex"
    static let tabMenus = [("技术", "tech"), ("创意", "creative"), ("好玩", "play"), ("Apple", "apple"), ("酷工作", "jobs"), ("交易", "deals"), ("城市", "city"), ("问与答", "qna"), ("最热", "hot"), ("全部", "all"), ("R2", "r2"), ("节点", "nodes")]
    static let tabUrl = "http://www.v2ex.com/?tab=%@"
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

