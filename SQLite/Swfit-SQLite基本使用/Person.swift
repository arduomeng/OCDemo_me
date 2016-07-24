//
//  Person.swift
//  01-SQLite基本使用
//
//  Created by xiaomage on 15/9/20.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit

class Person: NSObject {
    var id: Int = 0
    var age: Int = 0
    var name: String?
    
    
    // MARK: - 执行数据源CRUD的操作
    
    class func loadPersons() -> [Person]
    {
        let sql = "SELECT * FROM T_Person;"
        let res = SQLiteManager.shareManager().execRecordSQL(sql)
        var models = [Person]()
        for dict in res
        {
            models.append(Person(dict: dict))
        }
        return models
    }
    
    /**
    删除记录
    */
    func deletePerson() -> Bool
    {
        // 1.编写SQL语句
        let sql = "DELETE FROM T_Person WHERE age IS \(self.age);"
        
        // 2.执行SQL语句
        return SQLiteManager.shareManager().execSQL(sql)
    }
    
    /**
    更新
    */
    func updatePerson(name: String) -> Bool
    {
        // 1.编写SQL语句
        let sql = "UPDATE T_Person SET name = '\(name)' WHERE age = \(self.age);"
        print(sql)
        // 2.执行SQL语句
        return SQLiteManager.shareManager().execSQL(sql)
    }
    /**
    插入一条记录
    */
    func insertPerson() -> Bool
    {
        
        assert(name != nil, "必须要给name赋值")
        
        // 1.编写SQL语句
        let sql = "INSERT INTO T_Person" +
        "(name, age)" +
        "VALUES" +
        "('\(name!)', \(age));"
        
        // 2.执行SQL语句
        return SQLiteManager.shareManager().execSQL(sql)
    }
    
    // MARK: - 系统内部方法
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String
        {
        return "id = \(id), age = \(age), name = \(name)"
    }
}
