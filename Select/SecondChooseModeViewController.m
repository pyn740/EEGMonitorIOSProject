//
//  SecondChooseModeViewController.m
//  nirsit
//
//  Created by admin on 15/7/24.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "SecondChooseModeViewController.h"

@interface SecondChooseModeViewController ()

@end

@implementation SecondChooseModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_taskBtn.layer setCornerRadius:6.0];
    [_taskBtn.layer setBorderWidth:2];
    [_taskBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_monitorBtn.layer setCornerRadius:6.0];
    [_monitorBtn.layer setBorderWidth:2];
    [_monitorBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.rightBottomView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"SecondMode";
}

#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Calibration"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toTaskModeSegue"]) {
        UIViewController *destination = segue.destinationViewController;
        [destination setValue:@"SecondModeSelect" forKey:@"whoComeIn"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"TaskSelect"];
    }else if ([segue.identifier isEqualToString:@"toMonitorModeSegue"]){
        UIViewController *destination = segue.destinationViewController;
        [destination setValue:@"SecondModeSelect" forKey:@"whoComeIn"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Measure"];
    }
}

@end
