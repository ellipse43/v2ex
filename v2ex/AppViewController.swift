//
//  ViewController.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/14.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import Alamofire

class AppViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var parentNavigationController: UINavigationController?
    
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
//        parentNavigationController?.hidesBarsOnSwipe = true
        title = "最新"
        
        vTv.addSubview(vRc)
        view.addSubview(vTv)
        vTv.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        // fix
        vRc.superview?.sendSubviewToBack(vRc)
        
        vRc.beginRefreshing()
        v2exRefresh(vRc)
    }
    
    func v2exRefresh(sender: UIRefreshControl) {
        dispatch_async(dispatch_get_main_queue(), {
            Alamofire.request(.GET, "http://www.v2ex.com/api/topics/latest.json")
                .responseJSON { (request, response, data, error) in
                    if (error != nil) {
                        NSLog("Error")
                    } else {
                        self.vInfo = JSON(data!)
                    }
            }
            self.vTv.reloadData()
            if self.vRc.refreshing == true {
                self.vRc.endRefreshing()
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vInfo.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("v2ex", sender: self)
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
        
        if let id = vInfo[index]["member"]["avatar_normal"].string {
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
        
        if let id = vInfo[index]["member"]["username"].string {
            cell.username.text = id
        }
        
        if let id = vInfo[index]["created"].double {
            cell.created.text = timeFriendly(id)
        }
        
        if let id = vInfo[index]["node"]["title"].string {
            cell.node.text = "# \(id)"
        }
        
        if let id = vInfo[index]["replies"].number {
            cell.replies.text = id.stringValue
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "v2ex" {
            var vc = segue.destinationViewController as! DetailViewController
            var indexPath = vTv.indexPathForSelectedRow()
            if let index = indexPath {
                vc.vInfo = vInfo[index.row]
            }
        }
    }
    
}

