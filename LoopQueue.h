//
//  LoopQueue.h
//  nirsit
//
//  Created by admin admin on 16/3/16.
//  Copyright © 2016年 cqupt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoopQueue : NSObject

@property(nonatomic)NSMutableArray * elementData;

-(instancetype)init;
-(int)queueLength;
-(BOOL)enQueue:(NSObject *)item;
-(NSObject *)deQueue;
-(int)getDefaultSize;
-(NSObject *)currentItemWithNum:(int)num;

@end
