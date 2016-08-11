//
//  NBackItem.h
//  tryGame
//
//  Created by admin on 15/8/6.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBackItem : NSObject

@property char letter;
@property NSTimeInterval appearTime;
@property int correctFlag;
@property int tapCount;
@end
