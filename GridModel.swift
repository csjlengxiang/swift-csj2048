//
//  GridModel.swift
//  swift-csj2048
//
//  Created by csj on 15/6/30.
//  Copyright (c) 2015年 csj. All rights reserved.
//

import Foundation

class Gird {
    weak var view: GridView!
    var num: Int
    var pos: Int
    init (num: Int, pos: Int){
        self.num = num
        self.pos = pos
    }
}
/**
*  根据Change的start和end更新girds中两个girds的信息
*  注意girds是早就已经存在，我们只是相应的按照模拟的方法移动，因为我们在消失是直接采用gird让其消失，于是gird要保持一致，不能交换内容，要交换指向gird的地址
*/
struct Change {
    var start: Int
    var end: Int
    var view: GridView
}
/**
*  根据New的内容嵌入至gird，并加入view
*/
struct New {
    var num: Int
    var pos: Int
}
/**
*  根据Disa的内容将gird清空，并清空view
*/
struct Disa {
    // 此处本想用pos来跟上面统一，但是有个很大的问题是，pos后来变了
    var gird: Gird
    //var pos: Int
    var view: GridView
}

enum Dir {
    case Up
    case Down
    case Left
    case Right
}
class Girds16 {
    private var grids: [Gird] = {
        var ret: [Gird] = []
        for i in 0..<16 {
            ret.append(Gird(num: 0, pos: i))
        }
        return ret
    }()
    private var changes: [Change] = []
    private var news: [New] = []
    private var disas: [Disa] = []
    
    /**
    根据手势方向准备栈数据
    
    - returns: 返回栈数据
    */
    private func getStack(dir: Dir)->[[Gird]]{
        var ret: [[Gird]] = []
        switch dir {
        case Dir.Up:
            for y in 0..<4 {
                var girds: [Gird] = []
                for x in 0..<4 {
                    let num = x * 4 + y
                    girds.append(self.grids[num])
                }
                ret.append(girds)
            }
        case Dir.Down:
            for y in 0..<4 {
                var girds: [Gird] = []
                for var x = 3; x >= 0; x-- {
                    let num = x * 4 + y
                    girds.append(self.grids[num])
                }
                ret.append(girds)
            }
        case Dir.Left:
            for x in 0..<4 {
                var girds: [Gird] = []
                for y in 0..<4 {
                    let num = x * 4 + y
                    girds.append(self.grids[num])
                }
                ret.append(girds)
            }
        case Dir.Right:
            for x in 0..<4 {
                var girds: [Gird] = []
                for var y = 3; y >= 0; y-- {
                    let num = x * 4 + y
                    girds.append(self.grids[num])
                }
                ret.append(girds)
            }
        }
        return ret
    }
    
    /**
    如果某个方向有change，说明还可以继续
    
    - parameter dir: 方向
    
    - returns: 是否可继续
    */
    private func getCheck(dir: Dir)->Bool {
        clearResult()
        let girdss = getStack(dir)

        girdss.forEach { (girds) -> () in
            self.getResultByStack(girds: girds);
        }
        return changes.count > 0
    }
    func check()->Bool {
        return getCheck(Dir.Down) || getCheck(Dir.Up) || getCheck(Dir.Left) || getCheck(Dir.Right)
    }
    /**
    对于每一个栈[2,0,2,0]，如何得出: (核心算法)
    1、移动的集合
    2、消失的集合
    3、出现的集合
    
    - parameter girds: 栈
    */
    private func getResultByStack(girds a: [Gird]) {
        var low = 0
        let cnt = a.count
        var tmp: Gird! = nil
        for var i = 0; i < cnt; i++ {
            if a[i].num != 0 {
                if tmp == nil {
                    if a[i].pos != a[low].pos {
                        changes.append(Change(start: a[i].pos, end: a[low].pos, view: a[i].view))
                    }
                    tmp = a[i]
                } else if tmp.num == a[i].num {
                    if a[i].pos != a[low].pos {
                        changes.append(Change(start: a[i].pos, end: a[low].pos, view: a[i].view))
                    }
                    let num = a[i].num * 2
                    news.append(New(num: num, pos: a[low].pos))
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
    
    /**
    只有更新了模型才能获得新出现的位置
    */
    private func updateModel() {
        for change in changes {
            let tmp = grids[change.end]
            grids[change.end] = grids[change.start]
            grids[change.start] = tmp
            grids[change.end].pos = change.end
            grids[change.start].pos = change.start
            //grids[change.start].num = 0 //其实不要这个也是可以的，因为disa给置0了
              //移动到指定位置，原来的清空。上一种更节约内存
//            grids[change.end] = grids[change.start]
//            grids[change.end].pos = change.end
//            grids[change.start] = Gird(num: 0, pos: change.start)
        }
        disas.forEach {
            $0.gird.num = 0;
        }
        news.forEach {
            self.grids[$0.pos].num = $0.num
        }
    }
    /**
    更新模型后，获得新出现的位置，并更新模型
    */
    private func getAppear() {
        var a: [Bool] = [Bool](count: 16, repeatedValue: false)
        grids.forEach {
            if $0.num != 0 {
                a[$0.pos] = true
            }
        }
        var b: [Int] = []
        for var i = 0; i < 16; i++ {
            if !a[i] {
                b.append(i)
            }
        }
        if b.count != 0 {
            let r = Int(arc4random() % (UInt32)(b.count))
            // MARK: 这里随机出现的数字
            news.append(New(num: 2, pos: b[r]))
            grids[b[r]].num = 2
        }
    }
    
    private func clearResult(){
        changes.removeAll(keepCapacity: false)
        news.removeAll(keepCapacity: false)
        disas.removeAll(keepCapacity: false)
    }
}
// MARK: - Public func
extension Girds16{
    subscript(pos: Int) -> Gird {
        get {
            return grids[pos]
        }
        set {
            grids[pos] = newValue
        }
    }
    func getStart()->[New]{
        getAppear()
        getAppear()
        return self.news
    }
    func getResult(dir: Dir)->([Change], [New], [Disa]){
        getCheck(dir)
        updateModel()
        getAppear()
        return (changes, news, disas)
    }
}
