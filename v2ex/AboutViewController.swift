//
//  AboutViewController.swift
//  v2ex
//
//  Created by ellipse42 on 15/9/22.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    override func loadView() {
        Bundle.main.loadNibNamed("AboutViewController", owner: self, options: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
