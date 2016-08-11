//
//  ArithmaticViewController.h
//  nirsit
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"
#import "UnityView.h"
#import "UnityViewControllerBase.h"
#include "UnityAppController+ViewHandling.h"

@interface ArithmaticViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *brainBtn;
@property (weak, nonatomic) IBOutlet UIButton *level1Btn;
@property (weak, nonatomic) IBOutlet UIButton *level2Btn;
@property (weak, nonatomic) IBOutlet UIButton *level3Btn;
@property (weak, nonatomic) IBOutlet UIView *unityView;

@end
