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

class TabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var parentNavigationController: UINavigationController?
    var tabCategory: String?
    
    var vInfo: JSON = [] {
        didSet {
            vTv.reloadData()
        }
    }
    
    lazy var vTv: UITableView = {
        var _tv = UITableView()
        _tv.delegate = self
        _tv.dataSource = self
        _tv.registerClass(AppTableViewCell.self, forCellReuseIdentifier: "v2exCell")
        _tv.estimatedRowHeight = 100
        _tv.rowHeight = UITableViewAutomaticDimension
        _tv.separatorStyle = UITableViewCellSeparatorStyle.None
        return _tv
    }()
    
    lazy var vRc: UIRefreshControl = {
        var _rc = UIRefreshControl()
        _rc.addTarget(self, action: "v2exRefresh:", forControlEvents: .ValueChanged)
        return _rc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        let simpleAnimator = SimpleAnimator(frame: CGRectMake(0, 0, 320, 60))
        vTv.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                Alamofire.request(.GET, "http://www.v2ex.com/?tab=\(self.tabCategory!)")
                    .response { (request, response, data, error) in
                        if (error != nil) {
                            NSLog("Error")
                        } else {
                            if let doc = Kanna.HTML(html: data!, encoding: NSUTF8StringEncoding) {
                                var _vInfo = [JSON]()
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
                                    _vInfo.append(JSON(d))
                                }
                                self.vInfo = JSON(_vInfo)
                                NSOperationQueue.mainQueue().addOperationWithBlock {
                                    self.vTv.stopPullToRefresh()
                                }
                            }
                        }
                }
                
            }
        }, withAnimator: simpleAnimator)

        view.addSubview(vTv)
        vTv.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        vTv.startPullToRefresh()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vInfo.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = DetailViewController()
        var indexPath = vTv.indexPathForSelectedRow()
        if let index = indexPath {
            vc.vInfo = vInfo[index.row]
        }
        parentNavigationController!.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("v2exCell", forIndexPath: indexPath) as! AppTableViewCell
        var index = indexPath.row as Int
        
        if let id = vInfo[index]["avatar"].string {
            if let url = NSURL(string: "http:\(id)") {
                if let data = NSData(contentsOfURL: url){
                    cell.avatar.contentMode = UIViewContentMode.ScaleAspectFit
                    cell.avatar.image = UIImage(data: data)
                }
            }
        }
        
        if let id = vInfo[index]["title"].string {
            cell.title.numberOfLines = 0
            cell.title.text = id
        }
        
        if let id = vInfo[index]["username"].string {
            cell.username.text = id
        }
        
        if let id = vInfo[index]["created"].string {
            cell.created.text = id
        }
        
        if let id = vInfo[index]["node"].string {
            cell.node.text = "# \(id)"
        }
        
        if let id = vInfo[index]["replies"].string {
            cell.replies.text = id
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
}

