//
//  ViewController.swift
//  swift-csj2048
//
//  Created by csj on 15/6/30.
//  Copyright (c) 2015年 csj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // view
    var gridsView: GridsView!
    
    // model
    var girds: Girds16!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var width = UIScreen.mainScreen().applicationFrame.width
        var heigth = UIScreen.mainScreen().applicationFrame.height
    
        gridsView = GridsView(frame: CGRect(x: 10, y: 20, width: width - 20, height: width - 20))
        girds = Girds16()
        girds.getStart()
        oper(time: 1)
        
        self.view.addSubview(gridsView)
        var btn = UIButton(frame: CGRect(x: 0, y: 400, width: 100, height: 100))
        btn.setTitle("click1-up", forState: UIControlState.Normal)
        btn.addTarget(self, action: "clicked1:", forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        self.view.addSubview(btn)
        
        
        btn = UIButton(frame: CGRect(x: 0, y: 500, width: 100, height: 100))
        btn.setTitle("click2-down", forState: UIControlState.Normal)
        btn.addTarget(self, action: "clicked2:", forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        self.view.addSubview(btn)
        
        btn = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
        btn.setTitle("click3-left", forState: UIControlState.Normal)
        btn.addTarget(self, action: "clicked3:", forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        self.view.addSubview(btn)
        
        btn = UIButton(frame: CGRect(x: 100, y: 500, width: 100, height: 100))
        btn.setTitle("click3-right", forState: UIControlState.Normal)
        btn.addTarget(self, action: "clicked4:", forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        self.view.addSubview(btn)
    }
    
    func clicked1(sender: AnyObject){
        girds.getResult(Dir.Up)
        oper()
        if !girds.check() {
            println("游戏结束了哟")
        }
    }
    func clicked2(sender: AnyObject){
        
        girds.getResult(Dir.Down)
        oper()
        
        if !girds.check() {
            println("游戏结束了哟")
        }
    }
    func clicked3(sender: AnyObject){
        
        girds.getResult(Dir.Left)
        oper()
        
        if !girds.check() {
            println("游戏结束了哟")
        }
    }
    func clicked4(sender: AnyObject){
        
        girds.getResult(Dir.Right)
        oper()
        
        if !girds.check() {
            println("游戏结束了哟")
        }
    }
    func oper(time tm: NSTimeInterval = 0.3) {
        var changes = girds.changes
        
        var disas = girds.disas
        
        var news = girds.news
        // 提前生成nviews, 这个是为了消除快速点击view还没跟上的bug
        var nviews = [(GridView, Int)]()
        for new in news {
            var nview = GridView(frame: self.gridsView.bkFrame[new.pos])
            self.girds.grids[new.pos].view = nview
            self.gridsView.addSubview(nview)
            nviews.append((nview, new.num))
        }
        
        for change in changes {
            var x: CGFloat =  gridsView.bkFrame[change.end].origin.x + gridsView.bkFrame[change.end].size.width / 2.0
            var y: CGFloat =  gridsView.bkFrame[change.end].origin.y + gridsView.bkFrame[change.end].size.height / 2.0
            var center = CGPoint(x: x, y: y)
            change.view.moveToCenter(tm, center: center)
        }
        // 异步形成动画
        var nanoSeconds = Int64(tm * Double(NSEC_PER_SEC))
        // 当没有移动，直接出现
        if changes.count == 0 {
            nanoSeconds = Int64(0)
        }
        let time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
        dispatch_after(time, dispatch_get_main_queue(), {
            () -> Void in
            for disa in disas {
                disa.view.disappear()
            }
            for nview in nviews {
                nview.0.display(nview.1, time: tm)
            }
        })        
    }
}

