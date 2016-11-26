//
//  ProfileViewController.swift
//  v2ex
//
//  Created by ellipse42 on 15/9/8.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import Alamofire
import Kingfisher

class ProfileViewController: UIViewController, UIScrollViewDelegate {
    
    var un: String? {
        didSet {
            Alamofire.request(Config.memberURL, method: .get, parameters: ["username": un!])
                .responseJSON { response in
                    let res = JSON(response.result.value!)
                    if let x = res["username"].string {
                        self.username.text = x
                    }
                    
                    if let x = res["bio"].string {
                        self.bio.text = x
                    }
                    
                    if let x = res["avatar_large"].string {
                        if let url = URL(string: "http:\(x)") {
                            if let _ = try? Data(contentsOf: url){
                                self.avatar.kf.setImage(with: ImageResource.init(downloadURL: url))
                            }
                        }
                    }
            }
        }
    }
    
    lazy var scrollView: UIScrollView = {
        var v = UIScrollView()
        v.backgroundColor = UIColor.white
        v.isScrollEnabled = true
        // - self.navigationController!.navigationBar.frame.height
        v.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 1)
        v.delegate = self
        return v
    }()
    
    lazy var contentView: UIView = {
        var v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    lazy var life: UIImageView = {
        var v = UIImageView()
        v.image = UIImage(named: "life")
        v.layer.zPosition = 1
        return v
    }()
    
    lazy var avatar: UIImageView = {
        var v = UIImageView()
        v.backgroundColor = UIColor.black
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        v.layer.zPosition = 100
        return v
    }()
    
    lazy var username: UILabel = {
        var v = UILabel()
        return v
    }()
    
    lazy var bio: UILabel = {
        var v = UILabel()
        v.font = UIFont(name: "Helvetica Neue", size: 12)
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset < 0 {
            var lifeTransform = CATransform3DIdentity
            let sf = (-offset) / life.bounds.height
            let sv = ((life.bounds.height * (1.0 + sf)) - life.bounds.height) / 2.0
            lifeTransform = CATransform3DTranslate(lifeTransform, 0, sv, 0)
            lifeTransform = CATransform3DScale(lifeTransform, 1.0 + sf, 1.0 + sf, 0)
            life.layer.transform = lifeTransform
        } else {
            var lifeTransform = CATransform3DIdentity
            lifeTransform = CATransform3DTranslate(lifeTransform, 0, max(-life.bounds.height, -offset), 0)
            life.layer.transform = lifeTransform
        }
    }
    
    func setup() {
        for v in [username, bio] {
            contentView.addSubview(v)
        }
        scrollView.addSubview(contentView)
        view.addSubview(life)
        view.addSubview(avatar)
        view.addSubview(scrollView)
        
        let life_w = UIScreen.main.bounds.width
        let life_h = life_w / 3 * 1.5
        
        life.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.width.equalTo(life_w)
            make.height.equalTo(life_h)
        }
        
        scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }

        contentView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
        }
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(life_h)
            make.left.equalTo(view).offset(40)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        username.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(avatar.snp_bottom).offset(10)
            make.left.equalTo(view).offset(40)
        }
        
        bio.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(username.snp_bottom).offset(10)
            make.left.equalTo(view).offset(40)
        }
        
    }
}
