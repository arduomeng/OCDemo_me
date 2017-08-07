//
//  Incomplete.m
//  CSSessionDownloadExample
//
//  Created by user on 2017/5/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 tips:
 A download can be resumed only if the following conditions are met:
 The resource has not changed since you first requested it
 The task is an HTTP or HTTPS GET request
 The server provides either the ETag or Last-Modified header (or both) in its response
 The server supports byte-range requests
 The temporary file hasn’t been deleted by the system in response to disk space pressure
 */

/*
 
 http://www.tuicool.com/articles/uyQrIzi
 一：
 因为项目中的下载任务，资源的 URL 是有时效的，每一次请求资源的 URL 都会发生改变。当从 resumeData 中恢复出一个 NSURLSessionDownloadTask 后，由于在 resumeData 中包含了第一次请求的 request。所以开始任务后就会出错
 
 重新生成 ResumeData
 //1
 let savePath = "ResumeDataPlistFilePath"
 var resumeData = NSData(contentsOfFile: savePath)
 
 var resumeDataDict: NSMutableDictionary
 do {
 resumeDataDict = try NSPropertyListSerialization.propertyListWithData(resumeData!, operions: NSPropertyListReadOptions.Immutable, format: nil) as! NSMutableDictionary
 }catch {
 print("Catch Error: \(error)")
 }
 
 //2
 var newResumeRequest = NSMutableURLRequest(URL: NSURL(string: "NewRemoteURL")!)
 newResumeRequest.addValue("bytes=\(resumeDataDict["NSURLSessionResumeBytesReceived"])", forHTTPHeaderField: "Range")
 
 //3
 var newResumeRequestData = NSKeyedArchiver.archivedDataWithRootObject(newResumeRequest)
 
 //4
 resumeDataDict.setObject(newResumeRequestData, forKey: "NSURLSessionResumeCurrentRequest")
 resumeDataDict.setObject("NewRemoteURL", forKey: "NSURLSessionResumeCurrentRequest")
 
 //5
 var newResumeData: NSData?
 do {
 newResumeData = try NSPropertyListSerialization.dataWithPropertyList(resumeDataDict, format: NSPropertyListFormat.XMLFormat_v1_0, option: 0)
 }catch {
 print("Catch Error: \(error)")
 }
 
 将 plist 文件重新读回应用中后是一个 NSData 文件，首先第一步将 NSData 通过 NSData(contentsOfFile: savePath) 从之前存储的 plist 文件中读取。并转化为 NSMutableDictionary
 
 第二步重新生成一个 NSURLMutableRequest ，之所以用 Mutable，是因为方便后面自定义信息。
 
 第二行代码通过为 NSURLMutableRequest 为 HTTP 请求的头部增加了一个 Range 字段，这样我们就可以从 Range 标明的位置执行下载了。
 
 第三步重新将 NSURLMutableRequest encode 为 NSData 。
 
 第四步讲新的 URL 和 新生成的 NSData 存储到字典中。
 
 第五步将字典重新序列化为 NSData 。
 
 这样就完成了，只要每一次停止时生成一个数据，开始时读取、修改数据。就可以在 URL 不断改变的情况下进行续传了。
 
 二：
 resumeData 应用关闭时无法获取resumData并保存。导致resumeData和tmp临时文件不匹配
 
 间隔固定时间／固定下载进度，将resumeData进行存储
 例如 ： 每当下载超过十分之一的时候,获取resumeData数据块和.tmp文件的路径,然后将resumeData写入到Cache文件夹下,将.tmp文件拷贝至Cache文件夹下;
 
 三：
 tmp临时文件被删除的情况
 
 将tmp文件进行保存，需要断点下载时，将临时文件copy至tmp目录相应的位置，继续下载。
 */
