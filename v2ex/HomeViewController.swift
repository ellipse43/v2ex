//
//  HomeViewController.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/16.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import UIKit
import PageMenu

class HomeViewController: UIViewController, CAPSPageMenuDelegate {
    
    @IBOutlet weak var barButton: UIButton!
    lazy var pageMenu: CAPSPageMenu = {
        var vcs : [UIViewController] = []
        
        for (idx, item) in Config.tabMenus.enumerate() {
            var vc = TabViewController()
            vc.title = item.0
            vc.tabCategory = item.1
            vc.parentNavigationController = self.navigationController
            vc.currentIdx = idx
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
        // fix: PageMenu Bug
        var _height = UIApplication.sharedApplication().statusBarFrame.size.height + self.navigationController!.navigationBar.frame.size.height
        var v = CAPSPageMenu(viewControllers: vcs, frame: CGRectMake(0.0, _height, self.view.frame.width, self.view.frame.height - _height), pageMenuOptions: args)
        
        v.delegate = self
        return v
    }()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "v2ex"
        view.addSubview(pageMenu.view)
    }
    
    func willMoveToPage(controller: UIViewController, index: Int) {
        
    }
    
    func didMoveToPage(controller: UIViewController, index: Int) {
        let vc = controller as! TabViewController
        if vc.isRefresh == false {
            vc.refresh()
        }
    }

}
