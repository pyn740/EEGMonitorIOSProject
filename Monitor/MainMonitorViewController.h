//
//  MainMonitorViewController.h
//  nirsit
//
//  Created by admin on 15/9/5.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"
#import "UnityView.h"
#import "UnityViewControllerBase.h"
#include "UnityAppController+ViewHandling.h"


@interface MainMonitorViewController : BaseViewController

@property(weak,nonatomic)NSString * whoComeIn;
@property(weak,nonatomic)NSDictionary * replayDataInfo;

@property (weak, nonatomic) IBOutlet UIView *dView;
@property (weak, nonatomic) IBOutlet UIView *taskView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;
@property (weak, nonatomic) IBOutlet UIView *unityView;
@property (weak, nonatomic) IBOutlet UIView *frontView;

@property (weak, nonatomic) IBOutlet UIButton *xaxisBtn;
@property (weak, nonatomic) IBOutlet UIButton *yaxisBtn;
@property (weak, nonatomic) IBOutlet UIButton *gridBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
