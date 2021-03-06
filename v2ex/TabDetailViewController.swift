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
import ActiveLabel

class TabDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let CELLNAME = "tabDetailViewCell"
    fileprivate var flag = true
    
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
                if let url = URL(string: "http:\(id)") {
                    if let _ = try? Data(contentsOf: url){
                        avatar.kf.setImage(with: ImageResource.init(downloadURL: url), placeholder: nil, options: nil)
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
        v.backgroundColor = UIColor.white
        return v
    }()
    
    lazy var _title: UILabel = {
        var v = UILabel()
        v.lineBreakMode = NSLineBreakMode.byWordWrapping
        v.numberOfLines = 0
        return v
    }()
    
    lazy var username: UILabel = {
        return Factory.createBasicLabel()
    }()
    
    lazy var created: UILabel = {
        return Factory.createBasicLabel()
    }()
    
    lazy var node: UILabel = {
        return Factory.createBasicLabel()
    }()
    
    lazy var repliesL: UILabel = {
        return Factory.createBasicLabel()
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
        var gesture = UITapGestureRecognizer(target: self, action: #selector(TabDetailViewController.profileAction(_:)))
        v.addGestureRecognizer(gesture)
        v.isUserInteractionEnabled = true
        v.tag = -1
        return v
    }()

    
    lazy var leftQuotationLabel: UILabel = {
        return Factory.createQuotationLabel("❝")
    }()
    
    lazy var rightQuotationLabel: UILabel = {
        return Factory.createQuotationLabel("❞")
    }()

    lazy var contentLabel: ActiveLabel = {
        var v = ActiveLabel()
        v.font = UIFont(name: "Helvetica Neue", size: 16)
        v.lineBreakMode = NSLineBreakMode.byWordWrapping
        v.numberOfLines = 0
        return v
    }()
    
//     fix
    lazy var scrollView: UIScrollView = {
        var v = UIScrollView()
        v.frame = UIScreen.main.bounds
        v.isScrollEnabled = true
        v.backgroundColor = UIColor.white
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
        v.register(TabRepliesViewCell.self, forCellReuseIdentifier: self.CELLNAME)
        v.estimatedRowHeight = 100
        v.rowHeight = UITableViewAutomaticDimension
        v.separatorStyle = UITableViewCellSeparatorStyle.none
        v.tableHeaderView = UIView()
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var height = CGFloat(0)
        for v in [_title, avatar, username, contentLabel, leftQuotationLabel, rightQuotationLabel, repliesLabel] as [Any] {
            height += (v as AnyObject).frame.size.height
        }
        
        header.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: height + navigationController!.navigationBar.frame.height)
        tableView.tableHeaderView = header
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: height)
        
        if let id = info["id"].string {
            let simpleAnimator = SimpleAnimator(frame: CGRect(x: 0, y: 0, width: 320, height: 60))
            tableView.addPullToRefreshWithAction({
                OperationQueue().addOperation {
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
        let back = UIButton(type: UIButtonType.custom)
        back.setImage(UIImage(named: "back"), for: UIControlState())
        back.addTarget(self, action: #selector(TabDetailViewController.backAction(_:)), for: UIControlEvents.touchUpInside)
        back.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        back.sizeToFit()
        let backItem = UIBarButtonItem(customView: back)
        navigationItem.leftBarButtonItem = backItem
        
        navigationController?.navigationBar.shadowImage = nil
        
        for v in [_title, avatar, username, created, repliesL, repliesLogo, node, contentLabel, leftQuotationLabel, rightQuotationLabel, repliesLabel] as [Any] {
            header.addSubview(v as! UIView)
        }
        header.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: 1000)
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
    
    func getContent(_ id: String) {
        Alamofire.request(Config.topicURL, method: .get, parameters: ["id": id])
            .responseJSON { response in
                self.contentLabel.text = JSON(response.result.value!)[0]["content"].string
        }
    }
    
    func getReplies(_ id: String) {
        Alamofire.request(Config.replyURL, method: .get, parameters: ["topic_id": id])
            .responseJSON { response in
                self.replies = JSON(response.result.value!)
                self.tableView.stopPullToRefresh()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELLNAME, for: indexPath) as! TabRepliesViewCell
        let index = indexPath.row as Int
        
        if let id = replies[index]["member"]["avatar_large"].string {
            if let url = URL(string: "http:\(id)") {
                cell.avatar.kf.setImage(with: ImageResource.init(downloadURL: url), placeholder: nil, options: nil)
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
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        // fix
        let gesture = UITapGestureRecognizer(target: self, action: #selector(TabDetailViewController.profileAction(_:)))
        cell.avatar.addGestureRecognizer(gesture)
        cell.avatar.isUserInteractionEnabled = true
        cell.avatar.tag = index
        
        cell.content.handleMentionTap { (user: String) -> () in
            self.profileView(user)
        }
        
        cell.content.handleURLTap { (url: URL) -> () in
            
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func profileAction(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "profileVC") as? ProfileViewController
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
    
    func profileView(_ user: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "profileVC") as? ProfileViewController
        profileVC?.un = user
        self.navigationController?.pushViewController(profileVC!, animated: true)
    }
    
    
}
