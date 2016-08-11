//
//  StroopItem.h
//  stroop
//
//  Created by admin on 15/8/12.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface StroopItem : NSObject

@property(nonatomic,strong) NSString * colorStr;
@property(nonatomic,strong) NSString * currentColor;
@property NSTimeInterval appearTime;
@property BOOL isCorrect;

@end
