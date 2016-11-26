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
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
    }
}
