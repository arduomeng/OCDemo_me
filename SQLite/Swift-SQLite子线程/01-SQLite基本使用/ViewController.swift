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
        let p = Person(dict: ["name": "zs", "age": 3])
//        print(p.insertPerson())
//        print(p.updatePerson("ww"))
//        print(p.deletePerson())
//        let models = Person.loadPersons()
//        print(models)
        p.insertQueuePerson()
        
        /*
        let start = CFAbsoluteTimeGetCurrent()
        
        for i in 0..<10000
        {
            let p = Person(dict: ["name": "zs + \(i)", "age": 3 + i])
            p.insertPerson()
        }
        
        print("耗时 = \(CFAbsoluteTimeGetCurrent() - start)")
        */
    }

}

