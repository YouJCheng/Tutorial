import UIKit
import Foundation
var greeting = "Hello, playground"
let item1 = DispatchWorkItem {
    for i in 0 ... 4 {
        print("item1 -> \(i)  thread: \(Thread.current)")
    }
}
let item2 = DispatchWorkItem {
    for i in 0 ... 4 {
        print("item2 -> \(i)  thread: \(Thread.current)")
    }
}
let item3 = DispatchWorkItem {
    for i in 0 ... 4 {
        print("item3 -> \(i)  thread: \(Thread.current)")
    }
}
let item4 = DispatchWorkItem {
    for i in 0 ... 4 {
        print("item4 -> \(i)  thread: \(Thread.current)")
    }
}
// Main Queue 異步任務，依照順序 print
//let mainQueue = DispatchQueue.main
//mainQueue.async(execute: item1)
//mainQueue.async(execute: item2)
//mainQueue.async(execute: item3)
//mainQueue.async(execute: item4)

// Global Queue 異步任務，隨機 print
//let globalQueue = DispatchQueue.global()
//globalQueue.async(execute: item1)
//globalQueue.async(execute: item2)
//globalQueue.async(execute: item3)
//globalQueue.async(execute: item4)

// 自定義 Concurrent Queue 異步任務, 隨機 print
//let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
//concurrentQueue.async(execute: item1)
//concurrentQueue.async(execute: item2)
//concurrentQueue.async(execute: item3)
//concurrentQueue.async(execute: item4)

//Main Queue 同步任務，deadlock
//let mainQueue = DispatchQueue.main
//mainQueue.sync(execute: item1)
//mainQueue.sync(execute: item2)
//mainQueue.sync(execute: item3)
//mainQueue.sync(execute: item4)

// Global Queue 同步任務，按照順序 print
//let globalQueue = DispatchQueue.global()
//globalQueue.sync(execute: item1)
//globalQueue.sync(execute: item2)
//globalQueue.sync(execute: item3)
//globalQueue.sync(execute: item4)

// 自定義 Concurrent Queue 異步任務, 隨機 print
//let serialQueue = DispatchQueue(label: "serial")
//serialQueue.sync(execute: item1)
//serialQueue.sync(execute: item2)
//serialQueue.sync(execute: item3)
//serialQueue.sync(execute: item4)
// 自定義 Concurrent Queue 同步任務, 隨機 print
//let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
//concurrentQueue.sync(execute: item1)
//concurrentQueue.sync(execute: item2)
//concurrentQueue.sync(execute: item3)
//concurrentQueue.sync(execute: item4)

// 網路請求範例
// 建立一個並行隊列
let queue = DispatchQueue(label: "com.apple.request", attributes: .concurrent)
// 異步執行
//queue.async {
//    print("開始請求數據 \(Date())  thread: \(Thread.current)")
//    sleep(10) // 模擬網路請求時間
//    print("請求數據完成 \(Date())  thread: \(Thread.current)")
//    queue.async {
//        print("開始處理數據 \(Date())  thread: \(Thread.current)")
//        sleep(5)//模拟数据处理
//        print("數據處理完成 \(Date())  thread: \(Thread.current)")
//        //切换到主队列，刷新UI
//        DispatchQueue.main.async {
//            print("刷新UI成功  \(Date())  thread: \(Thread.current)")
//        }
//    }
//}

// DispatchGroup
let group = DispatchGroup()
group.enter()
queue.async {
    print("第一次請求數據 \(Date())  thread: \(Thread.current)")
    sleep(10)
    group.leave()
}
group.wait() // 等待第一個 Request 結束
group.enter()
for i in 0 ..< 10 {
    queue.async {
        print("第二次請求數據\(i): \(Date())  thread: \(Thread.current)")
        sleep(5)
        group.leave()
    }
}
group.notify(queue: .global()) {
    print("數據請求結束")
}
print("executed")
