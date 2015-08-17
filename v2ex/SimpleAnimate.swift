//
//  SimpleAnimate.swift
//  v2ex
//
//  Created by ellipse42 on 15/8/17.
//  Copyright (c) 2015年 ellipse42. All rights reserved.
//

import Foundation
import Refresher
import QuartzCore
import UIKit

class SimpleAnimator: UIView, PullToRefreshViewDelegate {
    
    let layerLoader = CAShapeLayer()
    let imageLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layerLoader.lineWidth = 1
        layerLoader.strokeColor = UIColor.blackColor().CGColor
        layerLoader.strokeEnd = 0
        layerLoader.fillColor = UIColor.clearColor().CGColor
        
        imageLayer.cornerRadius = 10.0
        imageLayer.contents = UIImage(named:"refresh")?.CGImage
        imageLayer.masksToBounds = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pullToRefresh(view: PullToRefreshView, progressDidChange progress: CGFloat) {
        layerLoader.strokeEnd = progress
    }
    
    func pullToRefresh(view: PullToRefreshView, stateDidChange state: PullToRefreshViewState) {
        
    }
    
    func pullToRefreshAnimationDidEnd(view: PullToRefreshView) {
        layerLoader.removeAllAnimations()
    }
    
    func pullToRefreshAnimationDidStart(view: PullToRefreshView) {
        let pathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimationEnd.duration = 1.5
        pathAnimationEnd.repeatCount = 100
        pathAnimationEnd.fromValue = 1
        pathAnimationEnd.toValue = 0.5
        layerLoader.addAnimation(pathAnimationEnd, forKey: "strokeEndAnimation")
        
        let pathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
        pathAnimationStart.duration = 1.5
        pathAnimationStart.repeatCount = 100
        pathAnimationStart.fromValue = 0.5
        pathAnimationStart.byValue = -1
        layerLoader.addAnimation(pathAnimationStart, forKey: "strokeStartAnimation")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let superview = superview {
            if layerLoader.superlayer == nil {
                superview.layer.addSublayer(layerLoader)
            }
            if imageLayer.superlayer == nil {
                imageLayer.frame = CGRect(x: superview.frame.size.width / 2 - 10, y: superview.frame.size.height / 2 - 10, width: 20.0, height: 20.0)
                superview.layer.addSublayer(imageLayer)
            }
            let center = CGPoint(x: superview.frame.size.width / 2, y: superview.frame.size.height / 2)
            let bezierPathLoader = UIBezierPath(arcCenter: center, radius: CGFloat(10), startAngle: CGFloat(-M_PI / 2), endAngle: CGFloat(2 * M_PI - M_PI / 2), clockwise: true)
            layerLoader.path = bezierPathLoader.CGPath
        }
    }
}