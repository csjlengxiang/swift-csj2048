//
//  GridsView.swift
//  swift-csj2048
//
//  Created by csj on 15/6/30.
//  Copyright (c) 2015年 csj. All rights reserved.
//

import UIKit

class GridsView: UIView {
    var bkFrame: [CGRect] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        // MARK: 初始化16个灰格子作为背景
        
        let mar: CGFloat = 10.0
        let d: CGFloat = 10.0
        let len: CGFloat = (width - mar * 2 - d * 4) / 4
        for i in 0..<4 {
            for j in 0..<4 {
                let y: CGFloat = mar + d / 2 + CGFloat(i) * (len + d)
                let x: CGFloat = mar + d / 2 + CGFloat(j) * (len + d)
                let frame = CGRect(x: x, y: y, width: len, height: len)
                let grid = GridView(frame: frame)
                grid.display(0, time: 1)
                bkFrame.append(frame)
                self.addSubview(grid)
            }
        }
        self.layer.cornerRadius = len / 5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - 动画
extension GridsView {
    /**
    根据模型数据，进行动画，并且绑定view
    
    - parameter girds: 模型
    - parameter time:  时间
    */
    func animation(changes: [Change], disas: [Disa], nviews: [(GridView, Int)], time tm: NSTimeInterval = 0.3) {
        changeAnimation(changes, time: tm)
        displayAnimation(changes.count, disas: disas, nviews: nviews, time: tm)
    }
    
    func changeAnimation(changes: [Change], time tm: NSTimeInterval) {
        for change in changes {
            let x: CGFloat =  self.bkFrame[change.end].origin.x + self.bkFrame[change.end].size.width / 2.0
            let y: CGFloat =  self.bkFrame[change.end].origin.y + self.bkFrame[change.end].size.height / 2.0
            let center = CGPoint(x: x, y: y)
            change.view.moveToCenter(tm, center: center)
        }
    }
    
    func displayAnimation(count: Int, disas: [Disa], nviews: [(GridView, Int)], time tm: NSTimeInterval){
        let dis_time = getChangeAnimationTime(time: tm, count: count)
        dispatch_after(dis_time, dispatch_get_main_queue(), {
            () -> Void in
            for disa in disas {
                disa.view.disappear()
            }
            for nview in nviews {
                nview.0.display(nview.1, time: tm)
            }
        })
    }

    func getChangeAnimationTime(time tm: NSTimeInterval, count: Int) -> dispatch_time_t {
        var nanoSeconds = Int64(tm * Double(NSEC_PER_SEC))
        if count == 0 {
            nanoSeconds = Int64(0)
        }
        let dis_time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
        return dis_time
    }
}