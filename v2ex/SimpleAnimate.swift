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
    }
    
    required init?(coder aDecoder: NSCoder) {
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
        if layerLoader.strokeEnd != 0.6 {
            layerLoader.strokeEnd = 0.6
        }
        
        let pathAnimationEnd = CABasicAnimation(keyPath: "transform.rotation")
        pathAnimationEnd.duration = 1.5
        pathAnimationEnd.repeatCount = HUGE
        pathAnimationEnd.removedOnCompletion = false
        pathAnimationEnd.fromValue = 0
        pathAnimationEnd.toValue = 2 * M_PI
        layerLoader.addAnimation(pathAnimationEnd, forKey: "strokeEndAnimation")        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let superview = superview {
            if layerLoader.superlayer == nil {
                layerLoader.lineWidth = 1
                layerLoader.strokeColor = UIColor.blackColor().CGColor
                layerLoader.fillColor = UIColor.clearColor().CGColor
                layerLoader.strokeEnd = 0.6
                layerLoader.lineCap = kCALineCapRound
                superview.layer.addSublayer(layerLoader)
            }
            if imageLayer.superlayer == nil {
                imageLayer.cornerRadius = 10.0
                imageLayer.contents = UIImage(named:"refresh")?.CGImage
                imageLayer.masksToBounds = true
                imageLayer.frame = CGRect(x: superview.frame.size.width / 2 - 10, y: superview.frame.size.height / 2 - 10, width: 20.0, height: 20.0)
                superview.layer.addSublayer(imageLayer)
            }
            let center = CGPoint(x: superview.frame.size.width / 2, y: superview.frame.size.height / 2)
            let bezierPathLoader = UIBezierPath(arcCenter: center, radius: CGFloat(10), startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
            layerLoader.path = bezierPathLoader.CGPath
            layerLoader.bounds = CGPathGetBoundingBox(bezierPathLoader.CGPath)
            layerLoader.frame = CGPathGetBoundingBox(bezierPathLoader.CGPath)
        }
    }
}