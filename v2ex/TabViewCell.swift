//
//  TabViewCell.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/15.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import UIKit

class TabViewCell: UITableViewCell {
    
    lazy var title: UILabel = {
        var v = UILabel()
        v.lineBreakMode = NSLineBreakMode.byWordWrapping
        v.numberOfLines = 0
        return v
    }()
    
    lazy var username: UILabel = {
        return Factory.createBasicLabel();
    }()

    lazy var created: UILabel = {
        return Factory.createBasicLabel();
    }()
    
    lazy var node: UILabel = {
        return Factory.createBasicLabel();
    }()
    
    lazy var replies: UILabel = {
        return Factory.createBasicLabel();
    }()
    
    lazy var repliesLogo: UIImageView = {
        var v = UIImageView()
        v.image = UIImage(named: "replies")
        return v
    }()
    
    lazy var avatar: UIImageView = {
        var v = UIImageView()
        v.backgroundColor = UIColor.black
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 15
        v.clipsToBounds = true
        return v
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        for v in [title, created, replies, avatar, repliesLogo, username, node] as [Any] {
            contentView.addSubview(v as! UIView)
        }
        
        title.snp_makeConstraints { (make) -> Void in
            // fix -> http://stackoverflow.com/questions/30364712/custom-cell-to-display-multiline-label-using-uitableviewautomaticdimension
            make.top.equalTo(contentView).offset(45)
            make.bottom.equalTo(contentView).offset(-20)
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(1.0)
        context?.move(to: CGPoint(x: 10, y: 20))
        context?.addLine(to: CGPoint(x: contentView.frame.width - 10, y: 20))
        context?.strokePath()
    }
    
}
