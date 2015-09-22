//
//  MenuViewController.swift
//  v2ex
//
//  Created by ellipse42 on 15/9/22.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var homeVC: UINavigationController?
    
    lazy var aboutVC: AboutViewController = {
        var v = AboutViewController()
        return v
    }()
    
    override func loadView() {
        NSBundle.mainBundle().loadNibNamed("MenuViewController", owner: self, options: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func homeAction(sender: AnyObject) {
        slideMenuController()?.changeMainViewController(homeVC!, close: true)
        
    }
    
    @IBAction func hotTopicAction(sender: UIButton) {
        
    }
    
    @IBAction func feedbackAction(sender: UIButton) {
        
    }
    
    @IBAction func settingActiong(sender: UIButton) {
        
    }
    
    @IBAction func aboutAction(sender: UIButton) {
        slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: aboutVC), close: true)
        
    }
    
}
