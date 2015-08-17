//
//  DetailViewController.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/15.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var vInfo: JSON = JSON(Dictionary<String, JSON>()) {
        didSet {
            if let id = vInfo["title"].string {
                titleLabel.text = id
                title = id
            }
            
            if let id = vInfo["username"].string {
                usernameLabel.text = id
            }
            
            if let id = vInfo["created"].string {
                createdLabel.text = id
            }
            
            if let id = vInfo["avatar"].string {
                if let url = NSURL(string: "http:\(id)") {
                    if let data = NSData(contentsOfURL: url){
                        avatar.contentMode = UIViewContentMode.ScaleAspectFit
                        avatar.image = UIImage(data: data)
                    }
                }
            }
            
            if let id = vInfo["content"].string {
                contentLabel.text = id
            }
            
            if let id = vInfo["replies"].string!.toInt() {
                if (id > 0) {
                    repliesLabel.text = "共\(id)回复"
                    if let id = vInfo["id"].string {
                        Alamofire.request(.GET, "http://www.v2ex.com/api/replies/show.json", parameters: ["topic_id": id])
                            .responseJSON { (request, response, data, error) in
                                if (error != nil) {
                                    NSLog("Error")
                                } else {
                                    self.replies = JSON(data!)
                                }
                        }
                    }
                }
            }

        }
    }
    
    var replies: JSON = [] {
        didSet {
            vTv.reloadData()
        }
    }
    
    lazy var titleLabel: UILabel = {
        var _l = UILabel()
        _l.lineBreakMode = NSLineBreakMode.ByWordWrapping
        _l.numberOfLines = 0
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

    lazy var usernameLabel: UILabel = {
        var _l = UILabel()
        _l.font = UIFont(name: "Helvetica Neue", size: 12)
        _l.textColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
        return _l
    }()
    
    lazy private var createdLabel: UILabel = {
        var _l = UILabel()
        _l.font = UIFont(name: "Helvetica Neue", size: 12)
        _l.textColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
        return _l
    }()
    
    lazy var leftQuotationLabel: UILabel = {
        var _l = UILabel()
        _l.font = UIFont(name: "Helvetica Neue", size: 28)
        _l.text = "❝"
        return _l
    }()
    
    lazy var rightQuotationLabel: UILabel = {
        var _l = UILabel()
        _l.font = UIFont(name: "Helvetica Neue", size: 28)
        _l.text = "❞"
        return _l
    }()

    lazy var contentLabel: UILabel = {
        var _l = UILabel()
        _l.font = UIFont(name: "Helvetica Neue", size: 16)
        _l.lineBreakMode = NSLineBreakMode.ByWordWrapping
        _l.numberOfLines = 0
        return _l
    }()
    
    // fix
    lazy var scrollView: UIScrollView = {
        var _sv = UIScrollView()
        _sv.frame = UIScreen.mainScreen().bounds
        _sv.scrollEnabled = true
        _sv.backgroundColor = UIColor.whiteColor()
        return _sv
    }()
    
    lazy var repliesLabel: UILabel = {
        var _l = UILabel()
        return _l
    }()
    
    lazy var vTv: UITableView = {
        var _tv = UITableView()
        _tv.delegate = self
        _tv.dataSource = self
        _tv.registerClass(RepliesTableViewCell.self, forCellReuseIdentifier: "v2exRepliesCell")
        _tv.estimatedRowHeight = 100
        _tv.rowHeight = UITableViewAutomaticDimension
        _tv.separatorStyle = UITableViewCellSeparatorStyle.None
        _tv.tableHeaderView = UIView()
        return _tv
    }()
    
    lazy var sv: UIView = {
        var _v = UIView()
        return _v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(animated: Bool) {
        var height = CGFloat(0)
        for v in [titleLabel, avatar, usernameLabel, createdLabel, contentLabel, leftQuotationLabel, rightQuotationLabel, repliesLabel] {
            height += v.frame.size.height
        }
        
        sv.frame.size = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: height)
        vTv.tableHeaderView = sv
        
//         scrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: height)
    }
    
    func setup() {
        let back = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        back.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        back.addTarget(self, action: "backAction:", forControlEvents: UIControlEvents.TouchUpInside)
        back.sizeToFit()
        let backItem = UIBarButtonItem(customView: back)
        navigationItem.leftBarButtonItem = backItem
        
        navigationController?.navigationBar.shadowImage = nil
        
        var height = CGFloat(0)
        // fix
        for v in [titleLabel, avatar, usernameLabel, createdLabel, contentLabel, leftQuotationLabel, rightQuotationLabel, repliesLabel] {
            height += v.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height
            sv.addSubview(v)
        }
        sv.frame.size = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 1000)
        vTv.tableHeaderView = sv
        view.addSubview(vTv)
        
        vTv.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
        }
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(10)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
        }
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp_bottom).offset(5)
            make.left.equalTo(view).offset(10)
        }
        
        usernameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_bottom).offset(7)
            make.left.equalTo(avatar.snp_right).offset(5)
        }
        
        createdLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_bottom).offset(7)
            make.right.equalTo(view).offset(-10)
        }
        
        leftQuotationLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(avatar.snp_bottom).offset(5)
            make.left.equalTo(view).offset(10)
        }
        
        rightQuotationLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentLabel.snp_bottom).offset(0)
            make.right.equalTo(view).offset(-10)
        }
        
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(leftQuotationLabel.snp_bottom).offset(0)
            make.bottom.equalTo(rightQuotationLabel.snp_top).offset(0)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
        }
        
        repliesLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(rightQuotationLabel.snp_bottom).offset(5)
            make.left.equalTo(view).offset(10)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("v2exRepliesCell", forIndexPath: indexPath) as! RepliesTableViewCell
        var index = indexPath.row as Int
        
        if let id = replies[index]["member"]["avatar_mini"].string {
            if let url = NSURL(string: "http:\(id)") {
                if let data = NSData(contentsOfURL: url){
                    cell.avatar.contentMode = UIViewContentMode.ScaleAspectFit
                    cell.avatar.image = UIImage(data: data)
                }
            }
        }
        
        if let id = replies[index]["content"].string {
            cell.content.numberOfLines = 0
            cell.content.text = id
        }
        
        if let id = replies[index]["member"]["username"].string {
            cell.username.text = id
        }
        
        if let id = replies[index]["created"].double {
            cell.created.text = timeFriendly(id)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    func backAction(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

}
