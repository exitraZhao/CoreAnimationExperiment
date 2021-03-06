//
//  CircleView.swift
//  CoreAnimationExperiment
//
//  Created by 赵一达 on 2016/11/10.
//  Copyright © 2016年 赵一达. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class CircleView: UIView {
    
    var circleLayer = CircleLayer()
    
    convenience init(frame: CGRect,string:String) {
        self.init()
        self.frame = frame
        var layerFrame = self.frame
        layerFrame.origin = CGPoint.init(x: 0, y: 0)
        circleLayer.frame = layerFrame
        circleLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(circleLayer)
    }
    
}
class CircleLayer: CALayer {
    enum Trend {
        case LIFT
        case RIGHT
    }
    let outsideRectSize: CGFloat = 50

    private var outsideRect = CGRect.init(x: 0, y: 0, width: 50, height: 50)
    private var lastProgress: CGFloat = 0.5
    private var movePoint: Trend!
    var progress: CGFloat = 0.0 {
        didSet{
            //外接矩形在左侧，则改变B点；在右边，改变D点
            if progress <= 0.5 {
                movePoint = .RIGHT
                
            }else{
                movePoint = .LIFT
                
            }
            
            self.lastProgress = progress
            let buff = (progress - 0.5)*(frame.size.width - outsideRectSize)
            let origin_x = position.x - outsideRectSize/2 + buff
            let origin_y = position.y - outsideRectSize/2;
            
            outsideRect = CGRect.init(x: origin_x, y: origin_y, width: outsideRectSize, height: outsideRectSize)
            
            setNeedsDisplay()
        }
    }
    var trend:Trend = .LIFT
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? CircleLayer {
            progress    = layer.progress
            outsideRect = layer.outsideRect
            lastProgress = layer.lastProgress
        }
    }
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        let offset = outsideRect.size.width / 3.6
        let movedDistance = (outsideRect.size.width * 1 / 6) * fabs(CGFloat(self.progress)-0.5)*2
        let rectCenter = CGPoint.init(x: outsideRect.origin.x + outsideRect.size.width/2 , y: outsideRect.origin.y + outsideRect.size.height/2)
        
        let pointA = CGPoint.init(x: rectCenter.x ,y: outsideRect.origin.y + movedDistance)
        let pointB = CGPoint.init(x: trend == .RIGHT ? rectCenter.x + outsideRect.size.width/2 : rectCenter.x + outsideRect.size.width/2 + movedDistance*2 ,y: rectCenter.y)
        let pointC = CGPoint.init(x: rectCenter.x ,y: rectCenter.y + outsideRect.size.height/2 - movedDistance)
        let pointD = CGPoint.init(x: trend == .RIGHT ? outsideRect.origin.x - movedDistance*2 : outsideRect.origin.x, y: rectCenter.y)
        
        let c1 = CGPoint.init(x: pointA.x + offset,y: pointA.y)
        let c2 = CGPoint.init(x: pointB.x,y: trend == .RIGHT ? pointB.y - offset : pointB.y - offset + movedDistance)
        
        let c3 = CGPoint.init(x: pointB.x,y: trend == .RIGHT ? pointB.y + offset : pointB.y + offset - movedDistance)
        let c4 = CGPoint.init(x: pointC.x + offset,y: pointC.y)
        
        let c5 = CGPoint.init(x: pointC.x - offset,y: pointC.y)
        let c6 = CGPoint.init(x: pointD.x,y: trend == .RIGHT ? pointD.y + offset - movedDistance : pointD.y + offset)
        
        let c7 = CGPoint.init(x: pointD.x,y: trend == .RIGHT ? pointD.y - offset + movedDistance : pointD.y - offset)
        let c8 = CGPoint.init(x: pointA.x - offset,y: pointA.y)
        
        let ovalPath = UIBezierPath()
        ovalPath.move(to: pointA)
        ovalPath.addCurve(to: pointB, controlPoint1: c1, controlPoint2: c2)
        ovalPath.addCurve(to: pointC, controlPoint1: c3, controlPoint2: c4)
        ovalPath.addCurve(to: pointD, controlPoint1: c5, controlPoint2: c6)
        ovalPath.addCurve(to: pointA, controlPoint1: c7, controlPoint2: c8)
        ovalPath.close()
        
        ctx.addPath(ovalPath.cgPath)
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setFillColor(UIColor.black.cgColor)
        ctx.drawPath(using: .fillStroke)
        
        
        
        
    }
}
