//
//  NBackItem.h
//  tryGame
//
//  Created by admin on 15/8/6.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArithmaticItem : NSObject

@property int leftDigit;
@property int rightDigit;
@property int correctAns;
@property NSTimeInterval appearTime;
@property BOOL isCorrect;
@end
