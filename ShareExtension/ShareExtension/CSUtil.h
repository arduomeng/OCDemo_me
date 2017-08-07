//
//  CSUtil.h
//  ShareExtension
//
//  Created by user on 2017/5/3.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSUtil : NSObject

+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateMobile:(NSString *)mobile;
+ (BOOL)isStringEmpty:(NSString *)str;
+ (BOOL)checkPassword:(NSString *) password;
+ (BOOL) validateCarNo:(NSString *)carNo;

+ (NSString *)trimStringEmpty:(NSString *)str;
+ (NSString *)trimStringNil:(NSString *)str;


+ (NSString *)md5:(NSString *)str;
+ (NSString *)md5OfFilePath:(NSString *)filePath;

+(NSString*)documentsDirectory;
+(NSString*)cachesDirectory;
+(NSString*)createDirectoryIfNotExists:(NSString *)draftPath;
+(NSString*)createFileIfNotExists:(NSString *)path;
+(BOOL)fileExists:(NSString*)file;

@end
