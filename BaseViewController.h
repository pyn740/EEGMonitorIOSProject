//
//  BaseViewController.h
//  nirsit
//
//  Created by admin on 15/7/21.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationInfo.h"

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic, strong)UIView * leftBottomView;
@property(nonatomic, strong)UIView * rightBottomView;

-(void)disableRightBottomView;
-(void)ableRightBottomView;
//-(void)disableLeftBottomView;
//-(void)ableLeftBottomView;
-(void)modifyRightLabel:(NSString *)str;
-(void)modifyRightImg:(NSString *)str;

@end
