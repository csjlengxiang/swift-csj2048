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

    /**
    准备初始数据
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        prepareRecognizer()
    }
    
    func prepare(){
        let width = UIScreen.mainScreen().applicationFrame.width
        gridsView = GridsView(frame: CGRect(x: 10, y: 20, width: width - 20, height: width - 20))
        girds = Girds16()
        let news = girds.getStart()
        let nviews = bandingNewDate(news)
        gridsView.animation([], disas: [], nviews: nviews, time: 1.0)
        self.view.addSubview(gridsView)
    }
    
    func check(){
        if !girds.check() {
            print("游戏结束了哟")
            let alertView = UIAlertView()
            alertView.title = "Defeat"
            alertView.message = "You lost..."
            alertView.addButtonWithTitle("Cancel")
            alertView.show()
        }
    }
    func getAnimationDate(dir: UISwipeGestureRecognizerDirection)->([Change], [New], [Disa])! {
        switch (dir) {
        case UISwipeGestureRecognizerDirection.Left:
            return girds.getResult(Dir.Left)
        case UISwipeGestureRecognizerDirection.Right:
            return girds.getResult(Dir.Right)
        case UISwipeGestureRecognizerDirection.Up:
            return girds.getResult(Dir.Up)
        case UISwipeGestureRecognizerDirection.Down:
            return girds.getResult(Dir.Down)
        default:
            return nil
        }
    }
    /**
    准备动画数据，其实就是new要生成一些view，并绑定到model，提早准备好数据防bug
    
    - parameter news:  new
    - parameter girds: 模型
    
    - returns: 返回元组用于动画
    */
    func bandingNewDate(news: [New]) -> [(GridView, Int)] {
        var nviews = [(GridView, Int)]()
        for new in news {
            let nview = GridView(frame: self.gridsView.bkFrame[new.pos])
            girds[new.pos].view = nview
            self.gridsView.addSubview(nview)
            nviews.append((nview, new.num))
        }
        return nviews
    }
    
    func oper(sender: UISwipeGestureRecognizer){
        let (changes, news, disas) = getAnimationDate(sender.direction)
        let nviews = bandingNewDate(news)
        gridsView.animation(changes, disas: disas, nviews: nviews, time: 0.3)
        check()
    }
    
    func prepareRecognizer() {
        var recognizer = UISwipeGestureRecognizer(target: self, action: "oper:")
        recognizer.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(recognizer)
        
        recognizer = UISwipeGestureRecognizer(target: self, action: "oper:")
        recognizer.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(recognizer)
        
        recognizer = UISwipeGestureRecognizer(target: self, action: "oper:")
        recognizer.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(recognizer)
        
        recognizer = UISwipeGestureRecognizer(target: self, action: "oper:")
        recognizer.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(recognizer)
    }
}

