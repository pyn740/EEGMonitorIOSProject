//
//  FirstChooseModeViewController.h
//  nirsit
//
//  Created by admin on 15/7/22.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"

@interface FirstChooseModeViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *taskBtn;
@property (weak, nonatomic) IBOutlet UIButton *monitorBtn;

- (IBAction)oneModeBeClicked:(id)sender;

@end
