//
//  LoopQueue.m
//  nirsit
//
//  Created by admin admin on 16/3/16.
//  Copyright © 2016年 cqupt. All rights reserved.
//

#import "LoopQueue.h"

#define DEFAULT_SIZE 51

@interface LoopQueue()

@property(nonatomic)int front;
@property(nonatomic)int rear;

@end

@implementation LoopQueue

-(instancetype)initWithCapacity:(NSUInteger)capacity{
    self.front = 0;
    self.rear = 0;
    self.elementData = [[NSMutableArray alloc] initWithCapacity:capacity];
    return self;
}

-(instancetype)init{
    self = [[LoopQueue alloc] initWithCapacity:DEFAULT_SIZE];
    return self;
}


-(int)queueLength{
    return (self.rear - self.front + DEFAULT_SIZE) % DEFAULT_SIZE;
}

-(BOOL)enQueue:(NSObject *)item{
    
//    if (![self isFull]) {
//        if (self.rear == DEFAULT_SIZE - 1 || self.rear == -1) {
//            self.elementData[0] = item;
//            self.rear = 0;
//            if (self.front == -1) {
//                self.front = 0;
//            }
//        }else{
//            self.elementData[++self.rear] = item;
//        }
//        return YES;
//    }else{
//        return NO;
//    }
 
    if ((self.rear + 1) % DEFAULT_SIZE == self.front) {
        return NO;
    }
    self.elementData[self.rear] = item;
    self.rear = (self.rear + 1) % DEFAULT_SIZE;
    return YES;
}

-(NSObject *)deQueue{
    if (self.front == self.rear) {
        return nil;
    }
    NSObject * obj = self.elementData[self.front];
    self.front = (self.front + 1) % DEFAULT_SIZE;
  
    return obj;
}

-(int)getDefaultSize{
    return DEFAULT_SIZE;
}

-(NSObject *)currentItemWithNum:(int)num{
    //NSLog(@"%d,%d,%@",self.front,num,self.elementData);
    return self.elementData[(self.front + num) % DEFAULT_SIZE];
}

@end
