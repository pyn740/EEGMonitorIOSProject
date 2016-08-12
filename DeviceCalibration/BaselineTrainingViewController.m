//
//  BaselineTrainingViewController.m
//  nirsit
//
//  Created by admin on 15/7/29.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "BaselineTrainingViewController.h"
#import "THProgressView.h"

@interface BaselineTrainingViewController (){
    THProgressView *progressView;
    CGFloat progress;
    NSTimer * tim;
}

@end

@implementation BaselineTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightBottomView setHidden:YES];
    progressView = [[THProgressView alloc] initWithFrame:CGRectMake(268, 360, 500, 20)];
    progressView.borderTintColor = [UIColor whiteColor];
    progressView.progressTintColor = [UIColor colorWithRed:0.0 green:157.0/255 blue:220.0/255 alpha:1.0];
    [progressView setProgress:0.0f animated:YES]; // floating-point value between 0.0 and 1.0
    [self.view addSubview:progressView];
    
    tim = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(controlProcess:) userInfo:nil repeats:YES];
}

-(void)controlProcess:(NSTimer *)timer{
    progress += 0.1f;
    [progressView setProgress:progress animated:YES];
    if (progress >= 1.1f) {
        [tim invalidate];
        [self performSegueWithIdentifier:@"toMeasureSegue" sender:self];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    progressView = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"BaselineTraining";
}

#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    [tim invalidate];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"TaskSelect"];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Measure"];
    
    UIViewController *destination = segue.destinationViewController;
    [destination setValue:_taskType forKey:@"taskType"];
    [destination setValue:[NSString stringWithFormat:@"%d",_taskID] forKey:@"taskID"];
}


@end
