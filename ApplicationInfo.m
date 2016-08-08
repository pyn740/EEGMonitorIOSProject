//
//  ApplicationInfo.m
//  nirsit
//
//  Created by admin on 15/9/5.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "ApplicationInfo.h"

@implementation ApplicationInfo

+ (ApplicationInfo *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static ApplicationInfo *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        _sharedObject.myDB = [[sqliteDB alloc] init];
        _sharedObject.someData = [[GetDataFromDevice alloc] init];
    });

    return _sharedObject;
}
@end
