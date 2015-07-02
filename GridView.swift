//
//  grid.swift
//  swift-csj2048
//
//  Created by csj on 15/6/30.
//  Copyright (c) 2015年 csj. All rights reserved.
//

import UIKit
// MARK: - 扩展UIView属性方便计算
extension UIView {
    var width: CGFloat {
        return self.frame.size.width
    }
    var height: CGFloat {
        return self.frame.size.height
    }
}
// MARK: - 初始化
class GridView: UIView {
    var lb: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = width / 5
        self.backgroundColor = UIColor.clearColor()
        
        lb = UILabel()
        lb.frame = CGRect(x: 0, y: 0, width: width, height: height)
        lb.backgroundColor = UIColor.clearColor()
        lb.textAlignment = NSTextAlignment.Center
        lb.font = UIFont.systemFontOfSize(30)
        self.addSubview(lb)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - 颜色
extension GridView {
    func getBKColor(value: Int) -> UIColor {
        switch value {
        case 0:
            return UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        case 2:
            return UIColor(red: 238.0/255.0, green: 228.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        case 4:
            return UIColor(red: 237.0/255.0, green: 224.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        case 8:
            return UIColor(red: 242.0/255.0, green: 177.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        case 16:
            return UIColor(red: 245.0/255.0, green: 149.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        case 32:
            return UIColor(red: 246.0/255.0, green: 124.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case 64:
            return UIColor(red: 246.0/255.0, green: 94.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        case 128, 256, 512, 1024, 2048:
            return UIColor(red: 237.0/255.0, green: 207.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        default:
            return UIColor.whiteColor()
        }
    }
    func getNumColor(value: Int) -> UIColor {
        switch value {
        case 0:
            return UIColor.clearColor()
        case 2, 4:
            return UIColor(red: 119.0/255.0, green: 110.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        default:
            return UIColor.whiteColor()
        }
    }
}
// MARK: - 动画
extension GridView {
    /**
    移动中心到center位置，然后完成completion动作
    
    :param: time       动画时间
    :param: center     移动中心
    */
    func moveToCenter(time: NSTimeInterval, center: CGPoint){
        UIView.animateWithDuration(time, animations: { () -> Void in
            self.center = center
        })
    }

    /**
    显示
    
    :param: value 数值
    :param: time  动画时间
    */
    func display(value: Int, time: NSTimeInterval){
        self.lb.text = "\(value)"
        self.lb.textColor = getNumColor(value)
        self.backgroundColor = getBKColor(value)
        
        self.transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.animateWithDuration(time / 2, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(1.12, 1.12)
            }, completion: { (_) -> Void in
                UIView.animateWithDuration(time / 4, animations: { () -> Void in
                    self.transform = CGAffineTransformMakeScale(0.9, 0.9)
                    }){
                        (_) -> Void in
                        UIView.animateWithDuration(time / 4, animations: { () -> Void in
                            self.transform = CGAffineTransformMakeScale(1, 1)
                        })
                    }
        })
    }
    func disappear(){
        self.removeFromSuperview()
    }
}