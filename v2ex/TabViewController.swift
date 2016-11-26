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
    
    let CELLNAME = "tabViewCell"
    var parentNavigationController: UINavigationController?
    var tabCategory: String?
    var currentIdx: Int?
    var isRefresh = false
    
    var infos: JSON = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        var v = UITableView()
        v.delegate = self
        v.dataSource = self
        v.register(TabViewCell.self, forCellReuseIdentifier: self.CELLNAME)
        v.estimatedRowHeight = 100
        v.rowHeight = UITableViewAutomaticDimension
        v.separatorStyle = UITableViewCellSeparatorStyle.none
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if currentIdx == 0 {
            refresh()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func refresh() {
        isRefresh = true
        let simpleAnimator = SimpleAnimator(frame: CGRect(x: 0, y: 0, width: 320, height: 60))
        tableView.addPullToRefreshWithAction({
                self.getInfos()
            }, withAnimator: simpleAnimator)
        tableView.startPullToRefresh()
    }
    
    func getInfos() {
        let uri: String = String(format: Config.tabUrl, self.tabCategory!)
        Alamofire.request(uri)
            .response { response in
                if let _ = response.error {
                    NSLog("Error")
                } else {
                    if let doc = Kanna.HTML(html: response.data!, encoding: String.Encoding.utf8) {
                        var _infos = [JSON]()
                        for node in doc.css("#Main > div:nth-child(2) > div.item") {
                            var d = Dictionary<String, String>()
                            if let title = node.at_css("table > tr > td:nth-child(3) > span.item_title > a") {
                                if let id = title["href"] {
                                    if let match = id.range(of: "\\d+", options: .regularExpression) {
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
                                    let v = msg.characters.split {$0 == "•"}.map { String($0) }
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
                        OperationQueue.main.addOperation {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TabDetailViewController()
        let indexPath = tableView.indexPathForSelectedRow
        if let index = indexPath {
            vc.info = infos[index.row]
        }
        parentNavigationController!.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELLNAME, for: indexPath) as! TabViewCell
        let index = indexPath.row as Int
        
        if let id = infos[index]["avatar"].string {
            if let url = URL(string: "http:\(id)") {
                cell.avatar.kf.setImage(with: ImageResource.init(downloadURL: url))
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
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
}

