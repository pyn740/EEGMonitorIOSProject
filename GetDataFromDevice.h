//
//  GetDataFromDevice.h
//  AgainToGetDataFromNIRSIT
//
//  Created by admin on 15/9/22.
//  Copyright © 2015年 cqupt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol updateDelegate <NSObject>

@optional
-(void)getData:(NSString *)sth;
-(void)showTimeInfo:(double)num;

@end

@interface GetDataFromDevice : NSObject

@property(nonatomic,weak)id<updateDelegate> delegate;

-(void)startGetDataFromDevice;
-(void)stopGetDataFromDevice;
-(void)readyToStart;
-(void)stopMeasure;

@end
