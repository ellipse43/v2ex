//
//  TabDetailViewController.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/15.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kanna
import Kingfisher

class TabDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let CELLNAME = "tabDetailViewCell"
    private var flag = true
    
    var info: JSON = JSON(Dictionary<String, JSON>()) {
        didSet {
            if let id = info["title"].string {
                _title.text = id
            }
            
            if let id = info["username"].string {
                username.text = id
            }
            
            if let id = info["created"].string {
                created.text = id
            }
            
            if let id = info["node"].string {
                node.text = "# \(id)"
            }
            
            if let id = info["replies"].string {
                repliesL.text = id
            }
            
            if let id = Int(info["replies"].string!) {
                if (id > 0) {
                    repliesLabel.text = "共\(id)回复"
                }
            }
            
            if let id = info["avatar"].string {
                if let url = NSURL(string: "http:\(id)") {
                    if let _ = NSData(contentsOfURL: url){
                        avatar.kf_setImageWithResource(Resource(downloadURL: url), placeholderImage: nil, optionsInfo: nil)
                    }
                }
            }
            
            if let id = info["id"].string {
                self.getContent(id)
            }

        }
    }
    
    var replies: JSON = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var header: UIView = {
        var v = UIView()
        v.backgroundColor = UIColor.whiteColor()
        return v
    }()
    
    lazy var _title: UILabel = {
        var v = UILabel()
        v.lineBreakMode = NSLineBreakMode.ByWordWrapping
        v.numberOfLines = 0
        return v
    }()
    
    lazy var username: UILabel = {
        var v = UILabel()
        v.font = UIFont(name: "Helvetica Neue", size: 12)
        v.textColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
        return v
    }()
    
    lazy var created: UILabel = {
        var v = UILabel()
        v.font = UIFont(name: "Helvetica Neue", size: 12)
        v.textColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
        return v
    }()
    
    lazy var node: UILabel = {
        var v = UILabel()
        v.font = UIFont(name: "Helvetica Neue", size: 12)
        v.textColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
        return v
    }()
    
    lazy var repliesL: UILabel = {
        var v = UILabel()
        v.font = UIFont(name: "Helvetica Neue", size: 12)
        v.textColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
        return v
    }()
    
    lazy var repliesLogo: UIImageView = {
        var v = UIImageView()
        v.image = UIImage(named: "replies")
        return v
    }()
    
    lazy var avatar: UIImageView = {
        var v = UIImageView()
        v.backgroundColor = UIColor.blackColor()
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 15
        v.clipsToBounds = true
        var gesture = UITapGestureRecognizer(target: self, action: Selector("profileAction:"))
        v.addGestureRecognizer(gesture)
        v.userInteractionEnabled = true
        v.tag = -1
        return v
    }()

    
    lazy var leftQuotationLabel: UILabel = {
        var v = UILabel()
        v.font = UIFont(name: "Helvetica Neue", size: 28)
        v.text = "❝"
        return v
    }()
    
    lazy var rightQuotationLabel: UILabel = {
        var v = UILabel()
        v.font = UIFont(name: "Helvetica Neue", size: 28)
        v.text = "❞"
        return v
    }()

    lazy var contentLabel: UILabel = {
        var v = UILabel()
        v.font = UIFont(name: "Helvetica Neue", size: 16)
        v.lineBreakMode = NSLineBreakMode.ByWordWrapping
        v.numberOfLines = 0
        return v
    }()
    
    
//     fix
    lazy var scrollView: UIScrollView = {
        var v = UIScrollView()
        v.frame = UIScreen.mainScreen().bounds
        v.scrollEnabled = true
        v.backgroundColor = UIColor.whiteColor()
        return v
    }()
    
    lazy var repliesLabel: UILabel = {
        var v = UILabel()
        return v
    }()
    
    lazy var tableView: UITableView = {
        var v = UITableView()
        v.delegate = self
        v.dataSource = self
        v.registerClass(TabRepliesViewCell.self, forCellReuseIdentifier: self.CELLNAME)
        v.estimatedRowHeight = 100
        v.rowHeight = UITableViewAutomaticDimension
        v.separatorStyle = UITableViewCellSeparatorStyle.None
        v.tableHeaderView = UIView()
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var height = CGFloat(0)
        for v in [_title, avatar, username, contentLabel, leftQuotationLabel, rightQuotationLabel, repliesLabel] {
            height += v.frame.size.height
        }
        
        header.frame.size = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: height + navigationController!.navigationBar.frame.height)
        tableView.tableHeaderView = header
        
        scrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: height)
        
        if let id = info["id"].string {
            let simpleAnimator = SimpleAnimator(frame: CGRectMake(0, 0, 320, 60))
            tableView.addPullToRefreshWithAction({
                NSOperationQueue().addOperationWithBlock {
                    self.getReplies(id)
                }
            }, withAnimator: simpleAnimator)
            
            if (flag) {
                tableView.startPullToRefresh()
                flag = false
            }
        }
    }
    
    func setup() {
        let back = UIButton(type: UIButtonType.Custom)
        back.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        back.addTarget(self, action: "backAction:", forControlEvents: UIControlEvents.TouchUpInside)
        back.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        back.sizeToFit()
        let backItem = UIBarButtonItem(customView: back)
        navigationItem.leftBarButtonItem = backItem
        
        navigationController?.navigationBar.shadowImage = nil
        
        for v in [_title, avatar, username, created, repliesL, repliesLogo, node, contentLabel, leftQuotationLabel, rightQuotationLabel, repliesLabel] {
            header.addSubview(v)
        }
        header.frame.size = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 1000)
        tableView.tableHeaderView = header
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        _title.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(45)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
        }
        
        username.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(_title.snp_bottom).offset(5)
            make.left.equalTo(view).offset(10)
        }
        
        created.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(_title.snp_bottom).offset(5)
            make.left.equalTo(username.snp_right).offset(5)
        }
        
        node.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(_title.snp_bottom).offset(5)
            make.left.equalTo(created.snp_right).offset(5)
        }
        
        repliesL.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(_title.snp_bottom).offset(5)
            make.left.equalTo(repliesLogo.snp_right).offset(2)
        }
        
        repliesLogo.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(_title.snp_bottom).offset(7)
            make.right.equalTo(view).offset(-30)
        }
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(5)
            make.left.equalTo(view).offset(30)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        leftQuotationLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(username.snp_bottom).offset(5)
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
    
    func getContent(id: String) {
        Alamofire.request(.GET, "http://www.v2ex.com/api/topics/show.json", parameters: ["id": id])
            .response { (_, _, data, _) in
                self.contentLabel.text = JSON(data!)[0]["content"].string
        }
    }
    
    func getReplies(id: String) {
        Alamofire.request(.GET, "http://www.v2ex.com/api/replies/show.json", parameters: ["topic_id": id])
            .response { (_, _, data, _) in
                self.replies = JSON(data!)
                self.tableView.stopPullToRefresh()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELLNAME, forIndexPath: indexPath) as! TabRepliesViewCell
        let index = indexPath.row as Int
        
        if let id = replies[index]["member"]["avatar_large"].string {
            if let url = NSURL(string: "http:\(id)") {
                cell.avatar.kf_setImageWithResource(Resource(downloadURL: url), placeholderImage: nil, optionsInfo: nil)
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
            cell.created.text = Util.timePrettify(id)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        // fix
        let gesture = UITapGestureRecognizer(target: self, action: Selector("profileAction:"))
        cell.avatar.addGestureRecognizer(gesture)
        cell.avatar.userInteractionEnabled = true
        cell.avatar.tag = index
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func backAction(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func profileAction(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewControllerWithIdentifier("profileVC") as? ProfileViewController
        if sender.view!.tag == -1 {
            if let username = info["username"].string {
                profileVC!.un = username
            }
        } else {
            if let username = replies[sender.view!.tag]["member"]["username"].string {
                profileVC!.un = username
            }
        }
        navigationController?.pushViewController(profileVC!, animated: true)
    }
}
