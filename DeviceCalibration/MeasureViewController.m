//
//  MeasureViewController.m
//  nirsit
//
//  Created by admin on 15/7/30.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "MeasureViewController.h"
#import "CognitiveTaskViewController.h"
#import "BehaviorTaskViewController.h"

@interface MeasureViewController ()

@end

@implementation MeasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.leftBottomView setHidden:YES];
    [self.rightBottomView setHidden:YES];
    [_quitBtn.layer setCornerRadius:6.0];
    [_quitBtn.layer setBorderWidth:2];
    [_quitBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_goBtn.layer setCornerRadius:6.0];
    [_goBtn.layer setBorderWidth:2];
    [_goBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"Measure";
}

#pragma mark - back or next event

//-(void)backToLastMenu:(id)sender{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"BaselineTraining"];
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - button click event

- (IBAction)goToTask:(id)sender {
    if ([_taskType isEqualToString:@"Behavior"]) {
        switch (_taskID) {
            case 1:
            {
                [self performSegueWithIdentifier:@"toBalanceSegue" sender:self];
                break;
            }
            case 2:
            {
                [self performSegueWithIdentifier:@"toSquatSegue" sender:self];
                break;
            }
            default:
                break;
        }
    }else if ([_taskType isEqualToString:@"Cognitive"]) {
        switch (_taskID) {
            case 1:
            {
                [self performSegueWithIdentifier:@"toNBackSegue" sender:self];
                break;
            }
            case 2:
            {
                [self performSegueWithIdentifier:@"toArithmaticSegue" sender:self];
                break;
            }
            case 3:
            {
                [self performSegueWithIdentifier:@"toStroopSegue" sender:self];
                break;
            }
//            case 4:
//            {
//                [self performSegueWithIdentifier:@"toLodonSegue" sender:self];
//                break;
//            }
            default:
                break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"TakeTask"];
}

- (IBAction)quitMeasure:(id)sender {
    UIViewController * viewCon;
    for (UIViewController * uiController in self.navigationController.viewControllers) {
        if ([uiController isKindOfClass:[CognitiveTaskViewController class]] || [uiController isKindOfClass:[BehaviorTaskViewController class]]) {
            viewCon = uiController;
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"TaskSelect"];
    [self.navigationController popToViewController:viewCon animated:YES];
}
@end
