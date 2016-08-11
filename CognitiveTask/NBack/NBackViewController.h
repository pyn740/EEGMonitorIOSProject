//
//  NBackViewController.h
//  nirsit
//
//  Created by admin on 15/8/12.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "UnityView.h"
#import "UnityViewControllerBase.h"
#include "UnityAppController+ViewHandling.h"

@interface NBackViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *back1Btn;
@property (weak, nonatomic) IBOutlet UIButton *back2Btn;
@property (weak, nonatomic) IBOutlet UIButton *back3Btn;

@property (weak, nonatomic) IBOutlet UIButton *brainBtn;
@property (weak, nonatomic) IBOutlet UIView *unityView;


@end
