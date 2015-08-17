//
//  Utils.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/16.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import Foundation

func timeFriendly(t: Double) -> String {
    var current = NSDate().timeIntervalSince1970
    var i = Int(current - t)
    var msg = ""
    switch i {
    case 0..<10:
        msg = "刚刚"
    case 10..<60:
        msg = "\(i)秒前"
    case 60..<3600:
        msg = "\(i / 60)分钟前"
    case 3600..<216000:
        msg = "\(i / 3600)小时前"
    default:
        msg = "\(i / 216000)天前"
    }
    return msg
}