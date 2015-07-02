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
    
    func check(){
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
        var direction = sender.direction
        switch (direction){
        case UISwipeGestureRecognizerDirection.Left:
            girds.getResult(Dir.Left)
        case UISwipeGestureRecognizerDirection.Right:
            girds.getResult(Dir.Right)
        case UISwipeGestureRecognizerDirection.Up:
            girds.getResult(Dir.Up)
        case UISwipeGestureRecognizerDirection.Down:
            girds.getResult(Dir.Down)
        default:
            break
        }
        gridsView.animation(girds)
        check()
    }
}

