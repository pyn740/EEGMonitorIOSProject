//
//  SummaryViewController.m
//  nirsit
//
//  Created by admin on 15/10/3.
//  Copyright © 2015年 cqupt. All rights reserved.
//

#import "SummaryViewController.h"
#import "SelectTaskViewController.h"
#import "FirstChooseModeViewController.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightBottomView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"Summary";
}

-(void)backToLastMenu:(id)sender{
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
