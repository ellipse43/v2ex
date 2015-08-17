//
//  RepliesTableViewCell.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/16.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import UIKit

class RepliesTableViewCell: UITableViewCell {
    
    lazy var content: UILabel = {
        var _l = UILabel()
        _l.font = UIFont(name: "Helvetica Neue", size: 14)
        _l.lineBreakMode = NSLineBreakMode.ByWordWrapping
        _l.numberOfLines = 0
        // fix
        let attributes = [
            NSUnderlineStyleAttributeName : 1,
            NSBackgroundColorAttributeName : UIColor.grayColor(),
            NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
            NSStrokeWidthAttributeName : 3.0
        ]
        
        _l.attributedText = NSAttributedString(string: "NSAttributedString", attributes: attributes)
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
    
    lazy var avatar: UIImageView = {
        var _i = UIImageView()
        _i.backgroundColor = UIColor.blackColor()
        _i.layer.masksToBounds = false
        _i.layer.cornerRadius = 10
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
        for v in [content, username, created, avatar] {
            contentView.addSubview(v)
        }
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.top.equalTo(contentView).offset(5)
            make.left.equalTo(contentView).offset(10)
        }
        
        username.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(7)
            make.left.equalTo(avatar.snp_right).offset(5)
        }
        
        created.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(7)
            make.right.equalTo(contentView).offset(-10)
        }
        
        content.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(avatar.snp_bottom).offset(0)
            make.bottom.equalTo(-5)
            make.left.equalTo(contentView).offset(25)
            make.right.equalTo(contentView).offset(-20)
        }
    }
}
