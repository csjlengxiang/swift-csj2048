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
        // MARK: 初始化16个灰格子
        
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
