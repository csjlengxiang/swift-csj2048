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
        
        var mar: CGFloat = 10.0
        var d: CGFloat = 10.0
        var len: CGFloat = (width - mar * 2 - d * 4) / 4
        for i in 0..<4 {
            for j in 0..<4 {
                var y: CGFloat = mar + d / 2 + CGFloat(i) * (len + d)
                var x: CGFloat = mar + d / 2 + CGFloat(j) * (len + d)
                var frame = CGRect(x: x, y: y, width: len, height: len)
                var grid = GridView(frame: frame)
                grid.display(0, time: 1)
                bkFrame.append(frame)
                self.addSubview(grid)
            }
        }
        self.layer.cornerRadius = len / 5
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - 动画
extension GridsView{
    /**
    根据模型数据，进行动画，并且绑定view
    
    :param: girds 模型
    :param: time  时间
    */
    func animation(girds: Girds16, time tm: NSTimeInterval = 0.3) {
        var changes = girds.changes
        var disas = girds.disas
        var nviews = perpare(girds.news, girds: girds)
        changeAnimation(girds.changes, time: tm)
        displayAnimation(girds, disas: disas, nviews: nviews, time: tm)
    }
    
    func changeAnimation(changes: [Change], time tm: NSTimeInterval) {
        for change in changes {
            var x: CGFloat =  self.bkFrame[change.end].origin.x + self.bkFrame[change.end].size.width / 2.0
            var y: CGFloat =  self.bkFrame[change.end].origin.y + self.bkFrame[change.end].size.height / 2.0
            var center = CGPoint(x: x, y: y)
            change.view.moveToCenter(tm, center: center)
        }
    }
    
    func displayAnimation(girds: Girds16, disas: [Disa], nviews: [(GridView, Int)], time tm: NSTimeInterval){
        var dis_time = getChangeAnimationTime(time: tm, count: girds.changes.count)
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
    /**
    准备动画数据，其实就是new要生成一些view，并绑定到model，提早准备好数据防bug
    
    :param: news  new
    :param: girds 模型
    
    :returns: 返回元组用于动画
    */
    func perpare(news: [New], girds: Girds16) -> [(GridView, Int)] {
        // 提前生成nviews, 这个是为了消除快速点击view还没跟上的bug
        var nviews = [(GridView, Int)]()
        for new in news {
            var nview = GridView(frame: self.bkFrame[new.pos])
            girds[new.pos].view = nview
            self.addSubview(nview)
            nviews.append((nview, new.num))
        }
        return nviews
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