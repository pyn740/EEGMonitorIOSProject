//
//  SelectTaskViewController.m
//  nirsit
//
//  Created by admin on 15/7/28.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "SelectTaskViewController.h"

@interface SelectTaskViewController ()

@end

@implementation SelectTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightBottomView setHidden:YES];
    //NSLog(@"%@",[ApplicationInfo sharedInstance].currentMode);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"TaskSelect";
}

#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    if ([self.whoComeIn isEqualToString:@"SecondModeSelect"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"SecondMode"];
    }else if ([self.whoComeIn isEqualToString:@"TestMode"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"AdminLogin"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
