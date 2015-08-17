//
//  PageMeuViewController.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/16.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import UIKit
import PageMenu

class PageMeuViewController: UIViewController {
    
    lazy var pageMenu: CAPSPageMenu = {
        var vcs : [UIViewController] = []
        
        for item in [("技术", "tech"), ("创意", "creative"), ("好玩", "play"), ("Apple", "apple"), ("酷工作", "jobs"), ("交易", "deals"), ("城市", "city"), ("问与答", "qna"), ("最热", "hot"), ("全部", "all"), ("R2", "r2"), ("节点", "nodes")] {
            var vc = TabViewController()
            vc.title = item.0
            vc.tabCategory = item.1
            vc.parentNavigationController = self.navigationController
            vcs.append(vc)
        }
        
        var args: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor.blackColor()),
            .BottomMenuHairlineColor(UIColor.blackColor()),
            .SelectedMenuItemLabelColor(UIColor.blackColor()),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .MenuHeight(40.0),
            .MenuMargin(20.0),
            .MenuItemWidth(40.0),
            .CenterMenuItems(true)
        ]
        
        var _pm = CAPSPageMenu(viewControllers: vcs, frame: CGRectMake(0.0, UIApplication.sharedApplication().statusBarFrame.size.height + self.navigationController!.navigationBar.frame.size.height, self.view.frame.width, self.view.frame.height), pageMenuOptions: args)
        return _pm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageMenu.view)
        navigationController?.navigationBar.topItem!.title = "v2ex"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
//        navigationController?.navigationBar.shadowImage = nil
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
