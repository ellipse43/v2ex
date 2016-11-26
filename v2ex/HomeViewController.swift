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
        
        for (idx, item) in Config.tabMenus.enumerated() {
            var vc = TabViewController()
            vc.title = item.0
            vc.tabCategory = item.1
            vc.parentNavigationController = self.navigationController
            vc.currentIdx = idx
            vcs.append(vc)
        }
        
        var args: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.black),
            .bottomMenuHairlineColor(UIColor.black),
            .selectedMenuItemLabelColor(UIColor.black),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .menuHeight(40.0),
            .menuMargin(20.0),
            .menuItemWidth(40.0),
            .centerMenuItems(true)
        ]
        // fix: PageMenu Bug
        var _height = UIApplication.shared.statusBarFrame.size.height + self.navigationController!.navigationBar.frame.size.height
        var v = CAPSPageMenu(viewControllers: vcs, frame: CGRect(x: 0.0, y: _height, width: self.view.frame.width, height: self.view.frame.height - _height), pageMenuOptions: args)
        
        v.delegate = self
        return v
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "v2ex"
        view.addSubview(pageMenu.view)
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        let vc = controller as! TabViewController
        if vc.isRefresh == false {
            vc.refresh()
        }
    }

}
