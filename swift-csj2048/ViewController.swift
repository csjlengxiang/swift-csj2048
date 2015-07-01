//
//  ViewController.swift
//  swift-csj2048
//
//  Created by csj on 15/6/30.
//  Copyright (c) 2015年 csj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var gridsView: GridsView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //grid = GridView(frame: CGRect(x: 20, y: 20, width: 100, height: 100))
        //self.view.addSubview(grid)
        
        var width = UIScreen.mainScreen().applicationFrame.width
        var heigth = UIScreen.mainScreen().applicationFrame.height
        
        gridsView = GridsView(frame: CGRect(x: 10, y: 20, width: width - 20, height: width - 20))
        
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
        
        girds = Girds16()
    }
    
    var girds: Girds16!
    
    func clicked1(sender: AnyObject){
        girds.getResult(Dir.Up)
        oper()
    }
    func clicked2(sender: AnyObject){
        
        girds.getResult(Dir.Down)
        oper()
        //grid.display(128, time: 2)
    }
    func clicked3(sender: AnyObject){
        
        girds.getResult(Dir.Left)
        oper()
    }
    func clicked4(sender: AnyObject){
        
        girds.getResult(Dir.Right)
        oper()
    }
    func oper(){
        var changes = girds.changes
        
        var disas = girds.disas
        
        var news = girds.news
        
        var tm = 0.2
        for change in changes {
            
            var center = gridsView.bkGrids[change.end].center
            
            change.view.moveToCenter(tm, center: center)
        }
        // 异步形成动画
        
        var nanoSeconds = Int64(tm * Double(NSEC_PER_SEC))
        
        let time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
        dispatch_after(time, dispatch_get_main_queue(), {
            () -> Void in
            for disa in disas {
                disa.view.disappear()
            }
            dispatch_after(time, dispatch_get_main_queue(), {
                () -> Void in
                for new in news {
                    var nview = GridView(frame: self.gridsView.bkGrids[new.pos].frame)
                    self.gridsView.addSubview(nview)
                    nview.display(new.num, time: tm)
                    self.girds.grids[new.pos].view = nview
                }
            })
        
        })
    }
}

