//
//  AppTableViewCell.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/15.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import UIKit

class AppTableViewCell: UITableViewCell {
    
    lazy var title: UILabel = {
        var _l = UILabel()
        _l.lineBreakMode = NSLineBreakMode.ByWordWrapping
        _l.numberOfLines = 0
//        _l.preferredMaxLayoutWidth = self.contentView.frame.size.width
        return _l
    }()
    
    lazy var username: UILabel = {
        var _l = UILabel()
        _l.font = UIFont(name: "Helvetica Neue", size: 12)
        _l.textColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
        return _l
    }()

    lazy var created: UILabel = {
        var _l = UILabel()
        _l.font = UIFont(name: "Helvetica Neue", size: 12)
        _l.textColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
        return _l
    }()
    
    lazy var node: UILabel = {
        var _l = UILabel()
        _l.font = UIFont(name: "Helvetica Neue", size: 12)
        _l.textColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
        return _l
    }()
    
    lazy var replies: UILabel = {
        var _l = UILabel()
        _l.font = UIFont(name: "Helvetica Neue", size: 12)
        _l.textColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
        return _l
    }()
    
    
    lazy var repliesLogo: UIImageView = {
        var _i = UIImageView()
        _i.image = UIImage(named: "replies")
        return _i
    }()
    
    lazy var avatar: UIImageView = {
        var _i = UIImageView()
        _i.backgroundColor = UIColor.blackColor()
        _i.layer.masksToBounds = false
        _i.layer.cornerRadius = 15
        _i.clipsToBounds = true
        return _i
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        for v in [title, created, replies, avatar, repliesLogo, username, node] {
            contentView.addSubview(v)
        }
        
        title.snp_makeConstraints { (make) -> Void in
            // fix -> http://stackoverflow.com/questions/30364712/custom-cell-to-display-multiline-label-using-uitableviewautomaticdimension
            make.top.equalTo(45)
            make.bottom.equalTo(-20)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-20)
        }
        
        username.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp_bottom).offset(5)
            make.left.equalTo(contentView).offset(10)
        }
        
        created.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp_bottom).offset(5)
            make.left.equalTo(username.snp_right).offset(5)
        }
        
        node.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp_bottom).offset(5)
            make.left.equalTo(created.snp_right).offset(5)
        }
        
        replies.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp_bottom).offset(5)
            make.left.equalTo(repliesLogo.snp_right).offset(2)
        }
        
        repliesLogo.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp_bottom).offset(7)
            make.right.equalTo(contentView).offset(-30)
        }
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(5)
            make.left.equalTo(contentView).offset(30)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.darkGrayColor().CGColor)
        CGContextSetLineWidth(context, 1.0)
        CGContextMoveToPoint(context, 10, 20)
        CGContextAddLineToPoint(context, contentView.frame.width - 10, 20)
        CGContextStrokePath(context)
    }
    
}
