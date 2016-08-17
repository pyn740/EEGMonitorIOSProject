//
//  SaveDeviceViewController.m
//  nirsit
//
//  Created by admin on 15/10/3.
//  Copyright © 2015年 cqupt. All rights reserved.
//

#import "SaveDeviceViewController.h"
#import "SelectTaskViewController.h"
#import "FirstChooseModeViewController.h"

@interface SaveDeviceViewController ()

@end

@implementation SaveDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_yesBtn.layer setCornerRadius:6.0];
    [_yesBtn.layer setBorderWidth:2];
    [_yesBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_noBtn.layer setCornerRadius:6.0];
    [_noBtn.layer setBorderWidth:2];
    [_noBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.rightBottomView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"Save";
}

-(void)backToLastMenu:(id)sender{
    //    if ([self.whoComeIn isEqualToString:[NSString stringWithFormat:@"%d",1]]) {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"SelectUser"];
    //    }else{
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Questionnaire"];
    //    }
    if ([self.whoComeIn isEqualToString:@"task"]) {
        SelectTaskViewController * selectTaskVC;
        for (UIViewController * vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SelectTaskViewController class]]) {
                selectTaskVC = (SelectTaskViewController *)vc;
                break;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"TaskSelect"];
        [self.navigationController popToViewController:selectTaskVC animated:YES];
    }else{
        FirstChooseModeViewController * selectTaskVC;
        for (UIViewController * vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[FirstChooseModeViewController class]]) {
                selectTaskVC = (FirstChooseModeViewController *)vc;
                break;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"FirstMode"];
        [self.navigationController popToViewController:selectTaskVC animated:YES];
    }
   
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"notSaveToDevice"]) {
        [[ApplicationInfo sharedInstance].myDB deleteRowdataTable:_itsTableName];
    }
    UIViewController *destination = segue.destinationViewController;
    [destination setValue:self.whoComeIn forKey:@"whoComeIn"];
}


@end
