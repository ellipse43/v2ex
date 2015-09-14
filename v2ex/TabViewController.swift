//
//  TabViewController.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/16.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import Alamofire
import Kanna
import Kingfisher

class TabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let CELLNAME = "tabViewCell"
    var parentNavigationController: UINavigationController?
    var tabCategory: String?
    
    var infos: JSON = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        var v = UITableView()
        v.delegate = self
        v.dataSource = self
        v.registerClass(TabViewCell.self, forCellReuseIdentifier: self.CELLNAME)
        v.estimatedRowHeight = 100
        v.rowHeight = UITableViewAutomaticDimension
        v.separatorStyle = UITableViewCellSeparatorStyle.None
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        let simpleAnimator = SimpleAnimator(frame: CGRectMake(0, 0, 320, 60))
        tableView.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                self.getInfos()
            }
            }, withAnimator: simpleAnimator)
        tableView.startPullToRefresh()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getInfos() {
        Alamofire.request(.GET, "http://www.v2ex.com/?tab=\(self.tabCategory!)")
            .response { (request, response, data, error) in
                if (error != nil) {
                    NSLog("Error")
                } else {
                    if let doc = Kanna.HTML(html: data!, encoding: NSUTF8StringEncoding) {
                        var _infos = [JSON]()
                        for node in doc.css("#Main > div:nth-child(2) > div.item") {
                            var d = Dictionary<String, String>()
                            if let title = node.at_css("table > tr > td:nth-child(3) > span.item_title > a") {
                                if let id = title["href"] {
                                    if let match = id.rangeOfString("\\d+", options: .RegularExpressionSearch) {
                                        d["id"] = id[match]
                                    }
                                }
                                d["title"] = title.text
                            }
                            if let username = node.at_css("table > tr > td:nth-child(3) > span.small.fade > strong:nth-child(3) > a") {
                                d["username"] = username.text
                            }
                            if let node = node.at_css("table > tr > td:nth-child(3) > span.small.fade > a") {
                                d["node"] = node.text
                            }
                            if let created = node.at_css("table > tr > td:nth-child(3) > span.small.fade") {
                                if let msg = created.text {
                                    let v = split(msg) {$0 == "•"}
                                    d["created"] = v.count == 4 ? v[2]: nil
                                }
                                
                            }
                            if let replies = node.at_css("table > tr > td:nth-child(4) > a") {
                                d["replies"] = replies.text
                            } else {
                                d["replies"] = "0"
                            }
                            if let avatar = node.at_css("table > tr > td:nth-child(1) > a > img") {
                                d["avatar"] = avatar["src"]
                            }
                            _infos.append(JSON(d))
                        }
                        self.infos = JSON(_infos)
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.tableView.stopPullToRefresh()
                        }
                    }
                }
        }
    }
    
    func setup() {
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = TabDetailViewController()
        var indexPath = tableView.indexPathForSelectedRow()
        if let index = indexPath {
            vc.info = infos[index.row]
        }
        parentNavigationController!.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CELLNAME, forIndexPath: indexPath) as! TabViewCell
        var index = indexPath.row as Int
        
        if let id = infos[index]["avatar"].string {
            if let url = NSURL(string: "http:\(id)") {
                cell.avatar.kf_setImageWithResource(Resource(downloadURL: url), placeholderImage: nil, optionsInfo: nil)
            }
        }
        
        if let id = infos[index]["title"].string {
            cell.title.numberOfLines = 0
            cell.title.text = id
        }
        
        if let id = infos[index]["username"].string {
            cell.username.text = id
        }
        
        if let id = infos[index]["created"].string {
            cell.created.text = id
        }
        
        if let id = infos[index]["node"].string {
            cell.node.text = "# \(id)"
        }
        
        if let id = infos[index]["replies"].string {
            cell.replies.text = id
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
}

