//
//  ViewController.swift
//  01-SQLite基本使用
//
//  Created by xiaomage on 15/9/20.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(__FUNCTION__)
//        let p = Person(dict: ["name": "zs", "age": 3])
//        print(p.insertPerson())
//        print(p.updatePerson("ww"))
//        print(p.deletePerson())
//        let models = Person.loadPersons()
//        print(models)
//        p.insertQueuePerson()
        
        
        /*
        let start = CFAbsoluteTimeGetCurrent()
        let manager = SQLiteManager.shareManager()
        
        // 开启事务
        manager.beginTransaction()
        
        for i in 0..<10000
        {
            let p = Person(dict: ["name": "zs + \(i)", "age": 3 + i])
            p.insertPerson()
            
            if i == 1000
            {
                manager.rollbackTransaction()
                // 注意点: 回滚之后一定要跳出循环停止更新
                break
            }
        }
        
        // 提交事务
        manager.commitTransaction()
        
        print("耗时 = \(CFAbsoluteTimeGetCurrent() - start)")
        */
        
        let start = CFAbsoluteTimeGetCurrent()
        let manager = SQLiteManager.shareManager()
        // 开启事务
         manager.beginTransaction()
        for i in 0..<10000
        {
            let sql = "INSERT INTO T_Person" +
                "(name, age)" +
                "VALUES" +
                "(?, ?);"
            
            manager.batchExecSQL(sql, args: "yy +\(i)", 1 + i)
        }
        // 提交事务
        manager.commitTransaction()
        print("耗时 = \(CFAbsoluteTimeGetCurrent() - start)")

    }

}

