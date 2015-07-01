//
//  GridModel.swift
//  swift-csj2048
//
//  Created by csj on 15/6/30.
//  Copyright (c) 2015年 csj. All rights reserved.
//

import Foundation

class Gird: NSObject {
    var view: GridView!
    var num: Int
    var x: Int
    var y: Int
    var pos: Int {
        get {
            return x * 4 + y
        }
        set {
            x = newValue / 4
            y = newValue % 4
        }
    }
    init (num: Int, x: Int, y: Int){
        self.num = num
        self.x = x
        self.y = y
    }
    init (num: Int, pos: Int){
        self.num = num
        self.x = pos / 4
        self.y = pos % 4
    }
}
struct Change {
    var start: Int
    var end: Int
    var gird: Gird
    var view: GridView
}
struct New {
    var num: Int
    var pos: Int
    //var gird: Gird
}
struct Disa {
    var gird: Gird
    var view: GridView
}

enum Dir {
    case Up
    case Down
    case Left
    case Right
}
class Girds16: NSObject {
    
    var grids: [Gird] = {
        var ret: [Gird] = []
        for x in 0..<4 {
            for y in 0..<4 {
                ret.append(Gird(num: 0, x: x, y: y))
            }
        }
        return ret
    }()
    var changes: [Change] = []
    var news: [New] = []
    var disas: [Disa] = []
    
    /**
    根据手势方向准备栈数据
    
    :returns: 返回栈数据
    */
    func getStack(dir: Dir)->[[Gird]]{
        var ret: [[Gird]] = []
        switch dir {
        case Dir.Up:
            for y in 0..<4 {
                var girds: [Gird] = []
                for x in 0..<4 {
                    var num = x * 4 + y
                    girds.append(self.grids[num])
                }
                ret.append(girds)
            }
        case Dir.Down:
            for y in 0..<4 {
                var girds: [Gird] = []
                for var x = 3; x >= 0; x-- {
                    var num = x * 4 + y
                    girds.append(self.grids[num])
                }
                ret.append(girds)
            }
        case Dir.Left:
            for x in 0..<4 {
                var girds: [Gird] = []
                for y in 0..<4 {
                    var num = x * 4 + y
                    girds.append(self.grids[num])
                }
                ret.append(girds)
            }
        case Dir.Right:
            for x in 0..<4 {
                var girds: [Gird] = []
                for var y = 3; y >= 0; y-- {
                    var num = x * 4 + y
                    girds.append(self.grids[num])
                }
                ret.append(girds)
            }
        }
        return ret
    }
    
    func getResult(dir: Dir){
        clearResult()
        var girdss = getStack(dir)
        for girds in girdss {
            getResult1(girds: girds)
        }
        
        pr()
        
        updateModel()
        
        pr()
        
        getAppear()
        
    
        // 根据模型来搞起
    }
    
    func pr() {
        for i in 0..<4 {
            for j in 0..<4 {
                var grid: Gird = grids[i * 4 + j]
                //var str: String = "(\(grid.num) \(grid.x) \(grid.y))"
                var str: String = "\(grid.num) "
                print(str)
            }
            println()
        }
        println()
    }
    
    func getResult1(girds a: [Gird]) {
        var low = 0
        var cnt = a.count
        var tmp: Gird! = nil
        for var i = 0; i < cnt; i++ {
            if a[i].num != 0 {
                if tmp == nil {
                    tmp = a[i]
                    changes.append(Change(start: a[i].pos, end: a[low].pos, gird: a[i], view: a[i].view))
                    
                } else if tmp.num == a[i].num {
                    changes.append(Change(start: a[i].pos, end: a[low].pos, gird: a[i], view: a[i].view))
                    var num = a[i].num * 2
                    news.append(New(num: num, pos: a[low].pos))
                    
                    println("\(num) \(a[low].pos)")
                    
                    disas.append(Disa(gird: tmp, view: tmp.view))
                    disas.append(Disa(gird: a[i], view: a[i].view))
                    low++
                    tmp = nil
                } else {
                    // 有值但不相等，堆砌，即清空当前值，上一层low
                    i--
                    low++
                    tmp = nil
                }
            }
        }
    }
    
    func updateModel() {
        for change in changes {
            
            var tmp = grids[change.end]
            grids[change.end] = grids[change.start]
            grids[change.start] = tmp
            grids[change.end].pos = change.end
            grids[change.start].pos = change.start
        }
        for disa in disas {
            disa.gird.num = 0
        }
        for new in news {
            grids[new.pos].num = new.num
        }
    }
    
    func getAppear() {
        var a: [Bool] = [Bool](count: 16, repeatedValue: false)
        grids.map { (grid) -> Void in
            if grid.num != 0 {
                a[grid.pos] = true
            }
        }
        var b: [Int] = []
        for var i = 0; i < 16; i++ {
            if !a[i] {
                b.append(i)
            }
        }
        var r = Int(arc4random() % (UInt32)(b.count))
        
        // MARK: 这里随机出现的数字
        news.append(New(num: 2, pos: b[r]))
        grids[b[r]].num = 2
        
        var cnt = 0
        grids.map { (gird) -> Void in
            if gird.num != 0 {
                cnt++
            }
        }
        
        su = su - disas.count + news.count
        println("ou \(su)")
        println("in \(cnt)")
    }
    var su = 0
    
    func clearResult(){
        changes.removeAll(keepCapacity: false)
        news.removeAll(keepCapacity: false)
        disas.removeAll(keepCapacity: false)
    }
}