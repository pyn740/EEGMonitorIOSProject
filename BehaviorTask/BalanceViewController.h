//
//  BalanceViewController.h
//  nirsit
//
//  Created by admin on 15/10/4.
//  Copyright © 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"
#import "UnityView.h"
#import "UnityViewControllerBase.h"
#include "UnityAppController+ViewHandling.h"

@interface BalanceViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *movieView;
@property (weak, nonatomic) IBOutlet UIButton *brainBtn;
@property (weak, nonatomic) IBOutlet UITextView *hintTextView;
@property (weak, nonatomic) IBOutlet UIView *unityView;

@end
