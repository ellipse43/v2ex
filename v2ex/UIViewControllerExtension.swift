//
//  UIViewControllerExtension.swift
//  v2ex
//
//  Created by ellipse42 on 15/9/22.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarItem() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
    }
}
