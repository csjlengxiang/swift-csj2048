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
        gridsView.animation(girds, time: 1.0)
        
        self.view.addSubview(gridsView)
        
//        var btn = UIButton(frame: CGRect(x: 0, y: 400, width: 100, height: 100))
//        btn.setTitle("click1-up", forState: UIControlState.Normal)
//        btn.addTarget(self, action: "clicked1:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        
//        self.view.addSubview(btn)
//        
//        
//        btn = UIButton(frame: CGRect(x: 0, y: 500, width: 100, height: 100))
//        btn.setTitle("click2-down", forState: UIControlState.Normal)
//        btn.addTarget(self, action: "clicked2:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        
//        self.view.addSubview(btn)
//        
//        btn = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
//        btn.setTitle("click3-left", forState: UIControlState.Normal)
//        btn.addTarget(self, action: "clicked3:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        
//        self.view.addSubview(btn)
//        
//        btn = UIButton(frame: CGRect(x: 100, y: 500, width: 100, height: 100))
//        btn.setTitle("click3-right", forState: UIControlState.Normal)
//        btn.addTarget(self, action: "clicked4:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        
//        self.view.addSubview(btn)
        
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
        
        
//        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//        [[self view] addGestureRecognizer:recognizer];
//        [recognizer release];
//        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//        
//        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//        [[self view] addGestureRecognizer:recognizer];
//        [recognizer release];
//        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//        
//        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
//        [[self view] addGestureRecognizer:recognizer];
//        [recognizer release];
//        
//        
//        UISwipeGestureRecognizer *recognizer;
//        
//        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
//        [[self view] addGestureRecognizer:recognizer];
//        [recognizer release];

        
    }
    
    func clicked1(sender: AnyObject?){
        girds.getResult(Dir.Up)
        gridsView.animation(girds)
        if !girds.check() {
            println("游戏结束了哟")
            let alertView = UIAlertView()
            alertView.title = "Defeat"
            alertView.message = "You lost..."
            alertView.addButtonWithTitle("Cancel")
            alertView.show()
        }
    }
    func clicked2(sender: AnyObject?){
        
        girds.getResult(Dir.Down)
        gridsView.animation(girds)
        
        if !girds.check() {
            println("游戏结束了哟")
            let alertView = UIAlertView()
            alertView.title = "Defeat"
            alertView.message = "You lost..."
            alertView.addButtonWithTitle("Cancel")
            alertView.show()
        }
    }
    func clicked3(sender: AnyObject?){
        
        girds.getResult(Dir.Left)
        gridsView.animation(girds)
        
        if !girds.check() {
            println("游戏结束了哟")
            let alertView = UIAlertView()
            alertView.title = "Defeat"
            alertView.message = "You lost..."
            alertView.addButtonWithTitle("Cancel")
            alertView.show()
        }
    }
    func clicked4(sender: AnyObject?){
        
        girds.getResult(Dir.Right)
        gridsView.animation(girds)
        
        if !girds.check() {
            println("游戏结束了哟")
            let alertView = UIAlertView()
            alertView.title = "Defeat"
            alertView.message = "You lost..."
            alertView.addButtonWithTitle("Cancel")
            alertView.show()
        }
    }
    
    func oper(sender: UISwipeGestureRecognizer){
        //划动的方向
        var direction = sender.direction
        //判断是上下左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.Left:
            println("Left")
            clicked3(nil)
            break
        case UISwipeGestureRecognizerDirection.Right:
            println("Right")
            clicked4(nil)
            break
        case UISwipeGestureRecognizerDirection.Up:
            println("Up")
            clicked1(nil)
            break
        case UISwipeGestureRecognizerDirection.Down:
            println("Down")
            clicked2(nil)
            break
        default:
            break;
        }
    }
}

